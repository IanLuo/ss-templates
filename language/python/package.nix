{
pkgs
, lib
}:

{
description ? ""
, name
, format ? "pyproject"
, installScript ? null
, python
, version
, buildInputs ? []
, src
}:

with lib.strings; python.pkgs.buildPythonApplication {
  installPhase = installPhase ? "";
  pname = name;
  version = version;
  format = format;
  propagatedBuildInputs = [python.pkgs.setuptools] ++ buildInputs;
  src = src;
  dontConfigure = true;
}

