{
sslib
, pkgs
, lib
}:

{
pythonVersion ? "python311"
, libs-default ? [] 
, libs-development ? [] 
}@inputs:
let
  pkgsBuiltins = if libs-default == null then [] else map (p: python.pkgs.${p}) libs-default ;
  pkgsBuiltinsDev = if libs-development == null then [] else map (p: python.pkgs.${p}) libs-development ;

  python = pkgs.${pythonVersion}.withPackages (ps: with ps; ([
    pip
  ] ++ pkgsBuiltins ++ pkgsBuiltinsDev)); 

in with pkgs; 
  sslib.defineUnit {
    name = "python-${pythonVersion}";
    value = python; 
    buildInputs = [ python ];
    passthrus = inputs // {
      libs-default = pkgsBuiltins; 
      libs-development = pkgsBuiltinsDev;
    };
  }
