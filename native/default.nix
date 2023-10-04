{ pkgs
, lib
, sslib
, ... }:

{
  python = pkgs.callPackage (import ./python sslib);
}
