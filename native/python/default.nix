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
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; [
    ps.pip
  ]); 

  otherPkgs = buildInputs(python.pkgs);

  buildapp = _: (pkgs.callPackage ./buildapp.nix { 
    inherit name version src python packages; 
  }); 

  testTool = pkgs.callPackage ./pytest.nix { inherit python testFolder sslib; };

in with pkgs; 
  sslib.defineUnit {
    name = name;

    src = src;

    sdk = python;
    
    buildapp = buildapp;

    dependencies = [ testTool python ] ++ otherPkgs;
  }

