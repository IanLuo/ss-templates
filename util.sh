#!/bin/bash

# check if package is installed wiht nix profile
makeSurePacakgeInstalled() {
  package_name=$1

  if nix profile list "$package_name" >/dev/null 2>&1; then
    echo "$package_name is installed"
  else
    installNixProfilePackage "$package_name"
  fi
}

installNixProfilePackage() {
  set -x
  nix profile install "$package_name"
  set +x
}
