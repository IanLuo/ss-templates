{ pkgs
, lib
, sslib
, ... }:

{
  python = pkgs.callPackage (import ./python sslib);
  pytest = pkgs.callPackage ./pytest.nix;
  package = pkgs.callPackage ./package.nix; 
}
