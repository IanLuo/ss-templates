{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
    let 
      pkgs = import nixpkgs { inherit system; };

      forAllSystems = pkgs.lib.genAttrs pkgs.lib.systems.flakeExposed;
    in with pkgs;{
      backend = callPackage ./backend {};

      frontend = callPackage ./frontend {};
      
      mobile = callPackage ./mobile {};

      native = callPackage ./native {};

      devShells.default = mkShell {
        buildInputs = [
          bashInteractive
        ];
      };
    });
}
