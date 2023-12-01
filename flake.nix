{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
    let 
      sslib = pkgs.callPackage ./sslib {};

      pkgs = import nixpkgs { inherit system; };

      forAllSystems = pkgs.lib.genAttrs pkgs.lib.systems.flakeExposed;

      commonParams = { inherit pkgs sslib; };
    in with pkgs; {
      language = callPackage ./language commonParams;

      powers = callPackage ./powers commonParams;

      devShells.default = mkShell {
        buildInputs = [
          bashInteractive
        ];
      };
    });
}
