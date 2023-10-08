{
name
, version
, buildInputs ? []
, src
, packages ? [] 
, python
, pyprojectPath ? null
}:

python.pkgs.buildPythonApplication {
  pname = name;

  version = version;

  format = "pyproject";

  src = src;

  propagatedBuildInputs = buildInputs ++ [
    python.pkgs.setuptools_scm
    python.pkgs.setuptools
    python.pkgs.wheel
  ];

  dontConfigure = true;

  preBuild = if pyprojectPath != null then 
  ''
    cp ${pyprojectPath} pyproject.toml
  ''
  else '' 
    cat > pyproject.toml <<EOF
      [build-system]
      requires = ["setuptools ~= 58.0", "cython ~= 0.29.0"]
      packages = ${builtins.toJSON packages}

      [project]
      name = "${name}"
      version = "${version}"
    EOF
  '';
}
