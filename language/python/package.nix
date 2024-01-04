{pkgs
, lib
, sslib 
}:

{
buildInputs
, src
, python
, name
, version
, description ? ""
, format 
, installScript ? null
}:

let


package = 
(python.pkgs.buildPythonApplication {
    pname = name;
    version = builtins.toString version;
    format = format;
    propagatedBuildInputs = [python.pkgs.setuptools] ++ buildInputs;
    src = src;
    dontConfigure = true;
  });
in sslib.defineUnit {
  value = package;
  isPackage = true;
  inherit name version;
}

