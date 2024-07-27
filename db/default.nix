{ pkgs
, sslib
}:
{
  postgres = pkgs.callPackage (import ./postgres sslib);
}
