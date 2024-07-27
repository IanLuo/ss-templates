{ pkgs
, sslib
}@commonParams:

with pkgs; {
  python = callPackage ./python commonParams;
}
