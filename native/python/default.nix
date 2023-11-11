sslib:

{
 pkgs
, pythonVersion ? "python39"
, name
, version
, buildInputs ? ps: []
, src ? null 
, lib
, testFolder ? "tests"
, packages ? []
, pyprojectPath ? null
, ...
}:

let
  otherPkgs = buildInputs(python.pkgs);

  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ])); 

  buildapp = _: (pkgs.callPackage ./buildapp.nix { 
    inherit name version src python packages; 
  }); 

  testTool = pkgs.callPackage ./pytest.nix { inherit python testFolder sslib; };

in with pkgs; 
  sslib.defineUnit {
    name = "${name}-sdk-python-${pythonVersion}";

    src = src;

    sdk = python;
    
    buildapp = buildapp;

    dependencies = [ testTool python ] ++ otherPkgs;
  }

