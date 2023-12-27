{
pkgs
, sslib
}:

{ 
testFolder ? "tests"
, python 
}:

let
  do-test-all = pkgs.writeScriptBin "do_test_all" ''
    echo "Running all tests in '${testFolder}'"
    pytest ${testFolder} $1
  '';

  code-coverage = pkgs.writeScriptBin "code_coverage" ''
    pytest --cov
  '';

in
  sslib.defineUnit {
    name = "python-test";

    buildInputs = [ 
      python.pkgs.pytest 
      python.pkgs.pytest-cov
      python.pkgs.pytest-mock
      do-test-all
      code-coverage
    ];
  }
