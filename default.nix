{
system
, pkgs
}:
let 
  sslib = pkgs.callPackage ./sslib {};
  commonParams = { inherit pkgs sslib; };
in with pkgs; {
  language = callPackage ./language commonParams;
  powers = callPackage ./powers commonParams;
}


