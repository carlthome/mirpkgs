#!/usr/bin/env bash
# Usage: ./init.sh <package_name>
#
# This script initializes a Nix package for a Python module from PyPI. Ensure
# that the package name is provided and that you have the `nix-init` command
# available.
#
set -euo pipefail

# Check if package name is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

# Check if nix-init is available.
if ! command -v nix-init &> /dev/null; then
    echo "nix-init command not found. Please install it first."
    exit 1
fi

# Initialize the Nix package for the specified Python module.
package_name=$1
nix-init --url https://pypi.org/project/${package_name}/ pkgs/development/python-modules/${package_name}/default.nix

# Add the generated default.nix to git.
git add pkgs/development/python-modules/${package_name}/default.nix
