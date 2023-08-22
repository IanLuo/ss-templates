#!/bin/bash

setupDirenv() {
  if [ ! -e ./.envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi  
}

setupNixDirenv() {
  setupDirenv


symbol="For nix-direnv"

if ! grep -q "$symbol" .envrc; then
cat >> .envrc <<'EOF'
# For nix-direnv

if ! has nix_direnv_version || nix_direnv_version 2.3.0; then
  source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/2.3.0/direnvrc" "sha256-Dmd+j63L84wuzgyjITIfSxSD57Tx7v51DMxVZOsiUD8="
fi
EOF
fi
}

setupNixDirenv
