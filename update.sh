#!/usr/bin/env bash
# Usage: ./update.sh <package_name>
#
# This script updates the Nix build definition for a specified package using
# the `nix-update` command. Ensure that the package name is provided and that
# you have the `nix-update` command available.
#
set -euo pipefail

# Check if package name is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

# Check if nix-update is available.
if ! command -v nix-update &> /dev/null; then
    echo "nix-update command not found. Please install it first."
    exit 1
fi

# Update the Nix build definition for the specified package.
package_name=$1
nix-update --flake ${package_name}
