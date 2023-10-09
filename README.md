# mirpkgs - Nix packages for reproducible MIR research

This repository contains a set of [Nix](https://nixos.org/nix/) packages for music information retrieval (MIR) research. It's currently mostly Python packages re-packaged from PyPI or GitHub. Long term these packages would preferably be included in [nixpkgs](https://github.com/nixos/nixpkgs) in order to be community maintained, and built and cached by [their system](https://hydra.nixos.org/project/nixpkgs), but for now this repository is a convenient way for me to share current progress and collaborate on development with friends and peers.

## Usage

First, install `nix` ([installation](https://nixos.org/download.html)) with [flakes enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes).

```sh
# List all packages.
nix flake show github:carlthome/mirpkgs

# Build all packages.
nix build github:carlthome/mirpkgs

# TODO Show how to start a Python REPL with packages, or how to create a shell.nix with `python3.withPackages`.
# nix run github:carlthome/mirpkgs -- python -c ""
```

## Develop

```sh
# Clone repo into working directory.
nix flake clone github:carlthome/mirpkgs --dest .

# Install development dependencies (or use direnv).
nix develop

# Open your text editor for a package by name.
nix edit .#msaf

# Update input flakes.
nix flake update --commit-lock-file

# Test that flake definition changes will work.
nix flake check

# Build all packages.
nix build
```

## FAQ

### Why does this repo exist?

TODO 
