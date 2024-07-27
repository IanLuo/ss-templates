{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      sslib = pkgs.callPackage ./sslib { };
      commonParams = { inherit pkgs sslib; };
    in
    with pkgs; {
      platform = callPackage ./platform commonParams;
      db = callPackage ./db commonParams;
      lib = sslib;
    };
}
