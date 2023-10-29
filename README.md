# mirpkgs - Nix packages for reproducible MIR research

This repository contains a set of [Nix](https://nixos.org/nix/) packages for music information retrieval (MIR) research. It's currently mostly Python packages re-packaged from PyPI or GitHub. Long term these packages would preferably be included in [nixpkgs](https://github.com/nixos/nixpkgs) in order to be community maintained, built and cached by [their system](https://hydra.nixos.org/project/nixpkgs), but for now this repository is a convenient way for me to share current progress and collaborate on development with friends and peers.

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

The goal is to have these packages live within nixpkgs, but that can take a while. Furthermore, not every MIR software might be of sufficient interest to a general audience such that it fits into the larger package set. As a transitionary period, and as a early development area, mirpkgs aims to drive public interest and collaboration on getting MIR specific software to benefit from having reproducible builds, without immediately tackling the larger integration work of getting into nixpkgs.

### Why not just use Docker instead?

For 80% of our common reproducibility problems, containerizing an application (e.g. a ML model training script) is a great choice. By doing that, you make sure you can re-run the same code with the same dependencies later, as long as you have the image still around.

Nix however, goes one step further and aims to have the original build also be fully deterministic and reproducible. While it's technically possible to write a Dockerfile where every command is carefully expressed to fail upon unexpected changes (like downloading the same URL but getting a checksum mismatch), most people don't write their builds that carefully, and the `docker build` tool ecosystem doesn't provide much help nor guidance to making sure that a Dockerfile can be built into the same image at a later time.

Aside from security concerns and long-term maintenance ergonomics, a practical benefit of having strong guarantees on reproducible builds is that installation errors can be isolated and re-run between collaborators (no "works on my machine"), to make debugging numerical discrepancies painless (or rather: possible).
