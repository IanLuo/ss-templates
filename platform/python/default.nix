{ sslib
, pkgs
, lib
}:

{ pythonVersion ? "python311"
, actions ? null
}@inputs:
let
  python = pkgs.${pythonVersion}.withPackages (ps: with ps; [
    pip
  ]);

  instantiate = ''
    python -m venv $PWD
  '';

in
with pkgs;
sslib.defineUnit {
  name = "python-${pythonVersion}";
  value = python;
  passthrus = inputs;
  instantiate = instantiate;
  actions = actions;
}
