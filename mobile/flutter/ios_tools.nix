{ pkgs ? <nixpkgs> }: {
  xcode =
    if !builtins.pathExists /Applications/Xcode.app
    then pkgs.xcode
    else null;
}
