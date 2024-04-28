pkgs:
{
  name
  , description
  , command 
}:
pkgs.writeScriptBin name ''
  ${command}
''
