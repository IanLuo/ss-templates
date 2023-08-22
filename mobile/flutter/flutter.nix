{ stdenv
, fetchzip
, version
, system
}:
let
  getMappedSystem = key:
    {
      "x86_64-linux" = "linux-x64";
      "x86_64-darwin" = "macos";
      "aarch64-linux" = "linux-aarch64";
      "aarch64-darwin" = "macos-arm64";
    }."${key}";

  platform = getMappedSystem system;

  url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_${platform}_${version}-stable.zip";
in
stdenv.mkDerivation {
  name = "flutter-${version}-darwin-arm64";
  src = fetchzip {
    url = url;
    hash = "sha256-yetEE65UP2Wh9ocx7nClQjYLHO6lIbZPay1+I2tDSM4=";
  };

  buildPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}
