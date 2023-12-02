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
, src
, test ? null
}:

let
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ] ++ buildInputsDev)); 

  package = if package == null then null else package {
    inherit python name version src buildInputs;
  };

in with pkgs; 
  sslib.defineUnit {
    inherit src;

    name = "${name}-sdk-python-${pythonVersion}";

    sdk = python;
    
    package = package;

    dependencies = [ python ] ++ buildInputsDev;
  }
