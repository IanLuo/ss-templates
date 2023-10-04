{
pkgs , stdenv , name, lib 

# the source of the unit, can be a git repo, or a local path
, src ? ./.

# script to run when build this unit, only used internally
# help to achieve the functions for this unit
, buildScript ? "" 

# if the unit has a sdk, will be here, atmost one
# used for 'nix develop'
, sdk ? null

# deveritions that needed to support this unit
, dependencies ? []

# env vars that will be set by this unit
, envs ? {} 

# function to build the app by user project, only some unit that needs to 
# produce and packages will have this function, by simply calling this function will
# build the app and package it
# this is for nix command 'nix build'
, buildapp ? null
}:

let
  exportsString = if envs != null 
    then lib.strings.concatMapStrings
      (x: "${x} \n") 
      (lib.attrsets.mapAttrsToList (x: y: "export ${x}=${y}") envs)
    else "";

  registerToEnv = ''
    export SS_UNITS=${name}:$SS_UNITS
  '';

in stdenv.mkDerivation {
  name = name;

  src = src;

  dontConfigure = true;

  buildPhase = ''
    mkdir -p $out/bin

    ${buildScript}
  '';

  propagatedBuildInputs = dependencies;

  passthru.script = builtins.concatStringsSep "\n" 
    ([ exportsString registerToEnv ] 
    ++ builtins.map 
      (x: x.script) 
      (lib.lists.filter (x: lib.attrsets.hasAttrByPath ["isUnit"] x) dependencies));

  passthru.sdk = sdk;
  
  passthru.buildapp = buildapp;

  passthru.dependencies = dependencies;

  passthru.isUnit = true;
}
