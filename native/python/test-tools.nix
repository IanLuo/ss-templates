{ 
pkgs
, testFolder ? "tests"
, python
, stdenv
}:

let
  do-test-all = pkgs.writeScriptBin "do_test_all" ''
    pytest ${testFolder}
  '';

  code-coverage = pkgs.writeScriptBin "code_coverage" ''
    pytest --cov
  '';

in
  stdenv.mkDerivation {
    name = "python-test";
    version = "0.0.1";
    src = ./.;

    propagatedBuildInputs = [ 
      python.pkgs.pytest 
      python.pkgs.pytest-cov
    ];

    buildPhase = ''
      mkdir -p $out/bin
       
      ln -s ${do-test-all}/bin/do_test_all $out/bin/do_test_all
      ln -s ${code-coverage}/bin/code_coverage $out/bin/code_coverage
    '';
  }
