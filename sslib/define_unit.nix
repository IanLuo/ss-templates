{ pkgs
, stdenv
, lib
}:

{ name
  # the source of the unit, can be a git repo, or a local path
, source
  # env vars that will be set by this unit
, envs ? null
, onstart ? null 
, install ? "" 
, actions ? null
, ...
}@inputs:

let
  actions_ = if actions != null then actions else {};

  make_action_command = action_str: name: pkgs.writeScriptBin "${name}" ''
    #!/usr/bin/env bash
    ${action_str}
    '';

  action_commands = lib.mapAttrsToList (n: action: make_action_command action "${name}.${n}") actions_;

  passthrus_ = {
    isUnit = true;
  } // (lib.attrsets.removeAttrs inputs [ "source" "install" "actions" ]);

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

  propagateActionCommands = actionCommands:
    if actionCommands == null then 
      "" 
    else 
      let
        actionCommandsString = lib.strings.concatMapStrings
          (x: "${x} ")
          (map (x: "${x}/bin/*") actionCommands);
      in
      ''
        mkdir -p $out/actions
        ln -s ${actionCommandsString} $out/actions
      ''; 

  installScriptForSource = source: 
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

  installPhaseScript = (installScriptForSource inputs.source) + (propagateActionCommands action_commands);

in
  let
    drv = stdenv.mkDerivation {
      name = name;
      src = inputs.source;
      dontConfigure = if (lib.attrsets.hasAttrByPath [ "dontConfigure" ] inputs) then inputs.dontConfigure else false;
      installPhase = installPhaseScript;
      passthru = passthrus_;
    };
  in
  drv
