{
python
, pkgs
, stdenv
, otherPackages ? []
}:

let 
  defaultPackages = [] // otherPackages;
in stdenv.mkDerivation {
  name
}


