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
, ...
}:

let
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; [
    ps.pip
  ] ++ buildInputs(ps));

  buildapp = packges: (pkgs.callPackage ./buildapp.nix { inherit name version src python; }); 

  testTool = pkgs.callPackage ./pytest.nix { inherit python testFolder sslib; };

in with pkgs; 
  sslib.defineUnit {
    name = "python-app-${name}-${version}";

    src = src;

    sdk = python;
    
    buildapp = buildapp;

    dependencies = [ testTool python ];
  }

