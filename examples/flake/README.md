# Example of using mirpkgs as nixpkgs overlay

This is an example flake that shows how to use mirpkgs as a nixpkgs overlay. A benefit of this approach is that we can easily migrate packages into nixpkgs without downstream users having to change much at all except updating their flake inputs.

## Usage example

```sh
# Create a directory and open it (any name works, it doesn't have to be "my-project").
mkdir my-project
cd my-project

# Initialize a git repository within the directory.
git init

# Add the example flake and stage them.
nix flake init -t github:carlthome/mirpkgs
git add .

# Now you can build the included example package (see default.nix), with packages in mirpkgs available via nixpkgs.
nix build
result/bin/python -c "import msaf"

# Or start the development shell (see shell.nix), again with packages in mirpkgs available via nixpkgs.
nix develop
python -c "import msaf"

# You can also add the included example package to your PATH without starting it, by running:
nix shell
python -c "import msaf"

# Or run the included example package directly, by running:
nix run
```
