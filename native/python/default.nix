{
 pkgs
, pythonVersion ? "python39"
, buildInputs ? []
, src
, lib
, testFolder ? "tests"
, ...}:
let
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; [
    ps.pip
    ps.pytest
    ps.pytest-cov
  ] ++ (builtins.map (pkg: ps.${pkg}) buildInputs));

  testTools = pkgs.callPackage ./test-tools.nix { inherit python; };

  tools = [
    testTools
  ];

in with pkgs; 
  stdenv.mkDerivation {
      name = "devne-native-python-app";
      version = "0.0.1";
      src = src;

      propagatedBuildInputs =  [ 
        python 
      ] ++ tools;

      buildPhase = ''
        mkdir -p $out/bin
      '';

      passthru.commands = builtins.fold (last: acc: acc ++ last) [] tools;

      passthru.python = python;
    }
