# make .envrc and add nix-env content to it

direnv_dir=$(pwd)/$(dirname "$0")
tool_dir=$(dirname "$direnv_dir")

source $tool_dir/util.sh
chmod +x $tool_dir/util.sh
makeSurePacakgeInstalled nixpkgs#direnv
makeSurePacakgeInstalled nixpkgs#nix-direnv 

chmod +x $direnv_dir/setup_envrc.sh
$direnv_dir/setup_envrc.sh

# then add direnv script to zsh and bash
# chmod +x $direnv_dir/setup_shell_rc.sh
# $direnv_dir/setup_shell_rc.sh # comment out for now, the file might not have permission to write
