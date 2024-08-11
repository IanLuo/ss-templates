{ pkgs
, stdenv
, lib
}:

{ name
  # the source of the unit, can be a git repo, or a local path
, source
  # env vars that will be set by this unit
, envs ? null
, onStart ? null 
, install ? "" 
, ...
}@inputs:

let

  envs_ = if envs == null then {} else inputs.envs;
  onStart_ = if onStart == null then "" else inputs.onStart;

  exportsString =
      lib.strings.concatMapStrings
        (x: "${x} \n")
        (lib.attrsets.mapAttrsToList (x: y: "export ${x}=${y}") envs_);

  # show all units
  registerToEnv = "export SS_UNITS=${lib.strings.escapeShellArg name}:$SS_UNITS";


  passthrus_ = {
    isUnit = true;
    script = builtins.concatStringsSep "\n" [ exportsString registerToEnv onStart_ ];
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
        mkdir -p $out
        ln -s ${source}/* $out
      ''
    else if sourceType == "path" then
      ''
        mkdir -p $out
        cp -r ${source}/* $out
      ''
    else
        inputs.install or "";

  buildPhaseScript = buildScriptForSource inputs.source;

in
  let
    drv = stdenv.mkDerivation {
      name = name;
      src = inputs.source;
      dontConfigure = if (lib.attrsets.hasAttrByPath [ "dontConfigure" ] inputs) then inputs.dontConfigure else false;
      installPhase = buildPhaseScript;
      passthru = passthrus_;
    };
  in
  drv
