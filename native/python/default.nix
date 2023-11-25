sslib:

{
 pkgs
, pythonVersion ? "python39"
, name
, version
, buildInputs ? ps: []
, src
, lib
, testFolder ? "tests"
, pyprojectPath ? null
, ...
}:

let
  otherPkgs = buildInputs(python.pkgs);

  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ])); 

  buildapp = pkgs.callPackage ./buildapp.nix { 
    inherit name version src python pkgs;
    buildInputs = otherPkgs;
  }; 

  testTool = pkgs.callPackage ./pytest.nix { inherit python testFolder sslib; };

in with pkgs; 
  sslib.defineUnit {
    name = "${name}-sdk-python-${pythonVersion}";

    src = (builtins.trace "src: ${src}" src);

    sdk = python;
    
    buildapp = buildapp;

    dependencies = [ testTool python ] ++ otherPkgs;
  }
