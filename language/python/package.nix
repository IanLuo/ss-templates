{
pkgs
, lib
, buildInputs
, src
, python
, name
, version
, description ? ""
, format 
, installScript ? null
}:

with lib.strings; python.pkgs.buildPythonApplication {
  pname = name;
  version = version;
  format = format;
  propagatedBuildInputs = [python.pkgs.setuptools] ++ buildInputs;
  src = src;
  dontConfigure = true;
}

