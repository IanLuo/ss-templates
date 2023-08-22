{ pkgs
, flutterVersion ? "3.10.6"
, folder
, name ? "flutter project"
}:
 stdenv.mkDerivation {
    name = "${name} - flutter(${flutterVersion})";
    buildInputs = baseInputs ++ [ cocoapods ];
    nativeBuildInputs = [ curl unzip ];
    shellHook = ''
      flutter_home=${folder.db}/build/sdk/
      if [ ! -d $flutter_home ]; then
        mkdir -p $flutter_home
        cp -r ${flutter}/. $flutter_home
        chmod -R u+wX $flutter_home
      fi

      export FLUTTER_ROOT=$flutter_home
      export PATH=$FLUTTER_ROOT/bin:$PATH
      export CC=$(xcrun --sdk iphoneos --find clang)
      export CXX=$(xcrun --sdk iphoneos --find clang++)
       
      echo $(flutter --version)
    '';
  };
