{
sslib
, pkgs
, system
}:
{
builtToolsVersion
, androidVersions
, systemImages
}:

let 
android-nixpkgs = pkgs.callPackage (import (builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
  })) {
    # Default; can also choose "beta", "preview", or "canary".
    channel = "stable";
  };

#TODO: map versions to packages
android-sdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
  cmdline-tools-latest
  build-tools-29-0-2
  platform-tools
  platforms-android-34
  platforms-android-32
  platforms-android-33
  platforms-android-31
  platforms-android-29
  platforms-android-28
  emulator
] ++ pkgs.lib.optionals (system == "aarch64-darwin") [
  system-images-android-34-default-arm64-v8a
]);
in
  sslib.defineUnit {
    name = "android-env";
    value = android-sdk;
  }
