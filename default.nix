{
  pkgs
}:
let 
  sslib = pkgs.callPackage ./sslib {};

  forAllSystems = pkgs.lib.genAttrs pkgs.lib.systems.flakeExposed;

  commonParams = { inherit pkgs sslib; };

  language = pkgs.callPackage ./language commonParams;

  powers = pkgs.callPackage ./powers commonParams;
in { inherit language powers; }

