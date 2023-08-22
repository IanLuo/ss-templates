{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.direnv

    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
