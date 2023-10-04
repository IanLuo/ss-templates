{
pkgs
, sslib
}:

{
  db = {
    postgres = pkgs.callPackage (import ./postgres sslib);
  };
}
