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
, libs-default ? [] 
, libs-development ? [] 
, buildFormat ? "wheel"
, installScript ? null
, src
, test ? "pytest"
}:

let
  pkgsBuiltins = if libs-default == null then [] else map (p: python.pkgs.${p}) libs-default ;
  pkgsBuiltinsDev = if libs-development == null then [] else map (p: python.pkgs.${p}) libs-development ;

  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ] ++ pkgsBuiltins ++ pkgsBuiltinsDev)); 

  package_ = if package == null then null else package {
    inherit python version src installScript name;
    buildInputs = pkgsBuiltins;
    format = buildFormat;
  };

in with pkgs; 
  sslib.defineUnit {
    inherit src;
    name = "${name}-sdk-python-${pythonVersion}";
    value = python; 
    passthrus = { "package" = package_; };
    buildInputs = [python];
  }
