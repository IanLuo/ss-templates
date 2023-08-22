{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
  let 
    pkgs = import nixpkgs { inherit system; };
  in with pkgs;{
    templates = {
      flutter = {
        path = ./flutter;
        description = "Flutter development environment";
      };
    };

    devShells.default = mkShell {
      buildInputs = [
        bashInteractive
      ];
    };
  });
}
