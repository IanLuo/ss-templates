{ pkgs
, sslib
}:
{ python
, name
, version
}:
let
  instantiateScript = ''
    if ! [ -f pyproject.toml ]; then
      echo "No pyproject.toml found in the current directory" >&2
      exit 1
    else
      poetry init 
    fi

    poetry install
  '';
in
with pkgs // sslib; defineUnit {
  name = "poetry";
  instantiate = instantiateScript;
  buildInputs = [ python.pkgs.poetry ];
}
