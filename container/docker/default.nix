{ pkgs
, name
, ...
}:
pkgs.dockerTools.buildLayeredImage {
  name = name;
  config = {
    Cmd = [ "echo" "hello" ]
      };
    contents = [
      {
        source = ./my-app;
        destination = "/app" }
        ];
      }

