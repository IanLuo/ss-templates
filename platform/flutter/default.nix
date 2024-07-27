{ stdenv
, fetchzip
, system
, sslib
}:

{ version
, channel ? "stable"
}:

let
  getMappedSystem = system:
    {
      "x86_64-linux" = "linux-x64";
      "x86_64-darwin" = "macos";
      "aarch64-linux" = "linux-aarch64";
      "aarch64-darwin" = "macos-arm64";
    };

  sha256 = {
    "3.16.6" = "sha256-PX+eHSeTRAZOJSfX3DQhTfWiPqzeTDCJEeHYGBZQ3wo=";
  };

  platform = getMappedSystem system;

  url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_${platform}_${version}-${channel}.zip";
in
let
  flutter = stdenv.mkDerivation {
    name = "flutter-${version}";
    src = fetchzip {
      url = url;
      hash = sha256 [ version ]; #TODO: handle missing version
    };

    buildPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

in
sslib.defineUnit {
  name = "flutter-${version}";
  value = flutter;
  passthrus = {
    version = version;
    shellHook = ''
      flutter_dir=~/.cache/flutter/${version}
      if [ ! -d $flutter_dir ]; then
        mkdir -p $flutter_dir
        cp -R ${flutter}/. $flutter_dir
        chmod -R +w $flutter_dir
      fi

      export FLUTTER_HOME=$flutter_dir/bin
      export PATH=$PATH:$flutter_dir/bin
    '';
  };
}
