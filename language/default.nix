commonParams:

{
  python = commonParams.pkgs.callPackage ./python 
    (commonParams // { package = (commonParams.pkgs.callPackage ./python/package.nix commonParams); });

  pytest = commonParams.pkgs.callPackage ./python/pytest.nix commonParams;
}
