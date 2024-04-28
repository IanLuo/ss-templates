{
pkgs , stdenv , lib 
, name ? "unknown"
, version ? "unknown"

# the source of the unit, can be a git repo, or a local path
, source 

# env vars that will be set by this unit
, envs ? {} 

, instantiate ? null

# actions are runnable script, by running this
# unit and with the name of the action, will call the action
# if no anbiguity, the action will be called directly
, actions ? {}

, listener ? [] 

, ...
}@inputs:

let
  exportsString = if envs != null 
    then lib.strings.concatMapStrings
      (x: "${x} \n") 
      (lib.attrsets.mapAttrsToList (x: y: "export ${x}=${y}") envs)
    else "";

# show all units
  registerToEnv = "export SS_UNITS=${lib.strings.escapeShellArg name}:$SS_UNITS";
  instantiate_ = if instantiate != null then instantiate else "";
  value_ = inputs.value or null;

  passthrus_ = {
    value = value_;
    script = builtins.concatStringsSep "\n" ([ exportsString registerToEnv instantiate_ ]);
    isUnit = true;
  };

  findOutType = x:
    if lib.isAttrs x then
      if lib.hasAttr "out" x then
        "drv"
      else
        "attrs"
    else if lib.isPath x then
      "path"
    else
      "material";

  buildScriptForSource = source:
    let 
      sourceType = findOutType source;
    in
      if sourceType == "drv" then
        ''
          set -x
          mkdir -p $out
          ln -s ${source}/* $out
        ''
      else if sourceType == "path" then
        ''
          mkdir -p $out
          cp -r ${source}/* $out
        ''
      else
        ''
          echo "source: ${source}" > $out
        '';

  buildPhaseScript = buildScriptForSource inputs.source;

in
  let 
    drv = stdenv.mkDerivation {
      name = "${name}-${version}";

      src = inputs.source;

      dontConfigure = if (lib.attrsets.hasAttrByPath ["dontConfigure"] inputs) then inputs.dontConfigure else false;

      buildPhase = buildPhaseScript;

      passthru = passthrus_;
    };
  in 
    drv
