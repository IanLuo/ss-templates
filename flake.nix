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
    in with pkgs;{
      backend = callPackage ./backend { inherit sslib; };

      frontend = callPackage ./frontend { inherit sslib; };
      
      mobile = callPackage ./mobile { inherit sslib; };

      native = callPackage ./native { inherit sslib; };
      
      powers = callPackage ./powers { inherit sslib; };

      devShells.default = mkShell {
        buildInputs = [
          bashInteractive
        ];
      };
    });
}
