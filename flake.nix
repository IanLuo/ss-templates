{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
    let 
      sslib = pkgs.callPackage ./sslib {};

      pkgs = import nixpkgs { inherit system; };

      commonParams = { inherit pkgs sslib; };
    in with pkgs; {
      devShells.default = mkShell {
        buildInputs = [
          bashInteractive
        ];
      };
    });
}
