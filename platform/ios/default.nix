{
sslib
, pkgs
}:
{
xcodeVersion
, xcodeBaseDir ? null
}:
let
  xcodeWrapper = pkgs.xcodeenv.composeXcodeWrapper {
    version = xcodeVersion;
    xcodeBaseDir = xcodeBaseDir;
  };
in 
  sslib.defineUnit {
    name = "ios-env-xcode-${xcodeVersion}";
    version = "0.0.1";
    buildInputs = with pkgs; [ 
      xcodeWrapper 
      cocoapods
      darwin.DarwinTools
    ];
  }
