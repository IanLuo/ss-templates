{
sslib
, pkgs
, lib
}:

{
pythonVersion ? "python311"
, name
, version
, buildInputs ? []
, src
, test ? null
, package ? null
}:

let
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ] ++ buildInputs)); 

  otherPkgs = with python.pkgs; buildInputs;

  testTool = if test == null then null else test { 
    inherit name version src python pkgs;
    testUnit = test;
  };

  package = if package == null then null else package { 
    inherit name version src python pkgs;
    buildInputs = otherPkgs;
  };

in with pkgs; 
  sslib.defineUnit {
    inherit src;

    name = "${name}-sdk-python-${pythonVersion}";

    sdk = python;
    
    package = package;

    dependencies = [ testTool python ] ++ otherPkgs;
  }
