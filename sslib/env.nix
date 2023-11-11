let 
  SSBase = "SS_PROJECT_BASE";
  RootFolder = "ss_conf";
  ConfigFile ="${RootFolder}/ss.yaml";
  FlakeFile = "${RootFolder}/flake.nix";
  DataFolder = ".ss_data";

  pathInProject = relative: "\$${SSBase}/${relative}";
  pathInDataFolder = relative: pathInProject "${DataFolder}/${relative}";
  pathInRootFolder = relative: pathInProject "${RootFolder}/${relative}";
in {
  inherit SSBase pathInProject pathInDataFolder;
}
