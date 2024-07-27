{}:

let
  # helpers
  optionalKey = rule: value:
    value == null || rule value;

  # output should contain follow keys
  cellValidationTemplate = {
    name = builtins.isString;
    version = builtins.isString;
    shellHook = optionalKey builtins.isString;
  };

  validateByTemplate = template: data:
    builtins.foldAttrs (key: rule: acc: acc && rule data.key) true template;

  # a cell in complete functionabl part that can be integrated into the env of the project, 
  # each cell should has an name, version, description, and will export some tools to the env
  # to avoid conflict, the env should have it's name space, like `cellName.toolName`

  # cells can connect to each other to form a graph, and pass the output as a attrset down to the next cell
  # as inputs, the cell using it will take the output and pass down, and adding something from it self, it's the 
  # cell's decision to make weathre to include the original output into the main output, but must pass down the
  # raw input for referencing
  defineCell = settings:
    {
      name = settings.name;
      version = settings.version;
      description = settings.description;

      inputs = settings.inputs or [ ];
      outputs = { };
    };

  # addOutput = f: cell:
  #   cell // { cell.output // (f cell); };

in
{
  defineCell = defineCell;
  # addOutput = addOutput;
}
