{
pkgs , stdenv , name, lib 

# the source of the unit, can be a git repo, or a local path
, src

# script to run when build this unit, only used internally
# help to achieve the functions for this unit
, buildScript ? "" 

# env vars that will be set by this unit
, envs ? {} 

, installPhase ? null

# this will be able to be used by other units as parameter
# if not provided, the unit itself will be used
, value ? null

, buildInputs ? []

, passthrus ? {}

, isPackage ? false

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
  value_ = inputs.value or null;

  passthrus_ = {
    inherit isPackage;
    value = value_;
    script = builtins.concatStringsSep "\n" ([ exportsString registerToEnv ]);
    isUnit = true;
  } // (inputs.passthrus or {});

in
  let 
    drv = stdenv.mkDerivation {
      name = "${inputs.name}";

      src = inputs.src;

      installPhase = inputs.installPhase or "";

      dontConfigure = if (lib.attrsets.hasAttrByPath ["dontConfigure"] inputs) then inputs.dontConfigure else false;

      buildPhase = ''
        mkdir -p $out/bin

        ${buildScript}
      '';

      propagatedBuildInputs = buildInputs;

      passthru = passthrus_;
    };
  in 
    drv
