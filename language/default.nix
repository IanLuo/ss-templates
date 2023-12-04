{
pkgs
, sslib
}@commonParams:

with pkgs; {
  python = callPackage ./python 
    (commonParams // { package = callPackage ./python/package.nix; });

  pytest = callPackage ./python/pytest.nix commonParams;
}
