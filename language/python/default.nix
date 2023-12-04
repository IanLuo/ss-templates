{
sslib
, pkgs
, lib
, package 
}:

{
pythonVersion ? "python311"
, name
, version
, buildInputsDev ? []
, buildInputs ? []
, buildFormat ? "wheel"
, installScript ? null
, src
, test ? null
}:

let
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ])); 

  pkgsBuiltins = map (p: python.pkgs.${p}) buildInputs;
  pkgsBuiltinsDev = map (p: python.pkgs.${p}) buildInputs;

  package_ = if package == null then null else package {
    inherit python name version src installScript;
    buildInputs = pkgsBuiltins;
    format = buildFormat;
  };

in with pkgs; 
  sslib.defineUnit {
    inherit src;

    name = "${name}-sdk-python-${pythonVersion}";

    sdk = python; 
    
    package = package_;

    dependencies = [ python ] ++ pkgsBuiltinsDev ++ pkgsBuiltins;
  }
