{
name
, version
, buildInputs ? []
, src
, python
, description ? ""
, authors ? []
, pkgs
, lib
, format ? "pyproject"
}:

with lib.strings; let
  pyproject = ''
      cat > pyproject.toml <<EOF
        [project]
        name = "${name}"
        version = "${version}"
        description = "${description}"
        authors = ${toJSON authors}

        [project.scripts]
        ${name} = "main:app"
      EOF
  '';
in
python.pkgs.buildPythonApplication {
  pname = name;
  version = version;
  format = format;
  propagatedBuildInputs = [python.pkgs.setuptools] ++ buildInputs;
  src = src;
  dontConfigure = true;
  # preBuild = pyproject;
}

