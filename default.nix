{
pkgs
}:
{
  backend = callPackage ./backend {};
  frontend = callPackage ./frontend {};
  mobile = callPackage ./mobile {};
  modules = callPackage ./modules {};
  tools = callPackage ./tools {};
}
