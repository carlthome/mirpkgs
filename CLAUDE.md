# CLAUDE.md — AI Assistant Guide for mirpkgs

## Project Overview

**mirpkgs** is a Nix flake providing a curated collection of Python packages for Music Information Retrieval (MIR) research. All packages target reproducible builds via the Nix package manager. The long-term goal is to upstream these packages into [nixpkgs](https://github.com/NixOS/nixpkgs).

- **Language**: Nix (package definitions)
- **Package ecosystem**: Python packages sourced from PyPI or GitHub
- **Supported systems**: `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`
- **Nix input**: `nixpkgs-unstable`

---

## Repository Structure

```
mirpkgs/
├── flake.nix                              # Flake entrypoint (packages, devShell, overlay, template)
├── default.nix                            # Builds Python environment with all packages + ipython
├── shell.nix                              # Dev shell (nixfmt, actionlint, nix-init, nix-update)
├── init.sh                                # Scaffold a new package from PyPI via nix-init
├── update.sh                              # Update a package to latest version via nix-update
├── .envrc                                 # direnv: `use flake`
├── .github/
│   ├── dependabot.yaml                    # Weekly GitHub Actions bumps
│   └── workflows/
│       ├── test.yaml                      # Flake check + per-package builds on PR/push
│       ├── build.yaml                     # Full build (workflow_dispatch / push to main)
│       ├── update.yaml                    # Weekly automated package updates
│       └── flakehub.yaml                  # Publish releases to FlakeHub on semver tags
├── pkgs/
│   └── development/
│       └── python-modules/
│           ├── default.nix                # Auto-discovers and loads all subdirectory packages
│           ├── <package-name>/
│           │   ├── default.nix            # Package definition
│           │   └── *.patch                # Optional patches
│           └── ...
└── examples/
    └── flake/                             # Template: use mirpkgs as a nixpkgs overlay
```

### Current packages (52 total)

`aeiou`, `alias-free-torch`, `argbind`, `audiocraft`, `audioscrape`, `auraloss`, `dali-dataset`, `demucs`, `descript-audio-codec`, `descript-audiotools`, `diffq`, `dora-search`, `einops-exts`, `ema-pytorch`, `encodec`, `flashy`, `hydra-colorlog`, `hyper-connections`, `jams`, `julius`, `laion-clap`, `lameenc`, `local-attention`, `madmom`, `mediapipe`, `mido`, `mirdata`, `msaf`, `musdb`, `museval`, `music21`, `opencv-contrib-python`, `openunmix`, `pedalboard`, `prefigure`, `pretty-midi`, `pyloudnorm`, `pystoi`, `pytest-runner`, `randomname`, `read-version`, `soundcloud-lib`, `stable-audio-tools`, `stempeg`, `submitit`, `torch-stoi`, `torchtext`, `treetable`, `v-diffusion-pytorch`, `vector-quantize-pytorch`, `vmo`, `x-transformers`

---

## Development Workflow

### Prerequisites

- Nix with flakes enabled ([install guide](https://nixos.org/download.html))
- `direnv` (optional but recommended — `use flake` in `.envrc` activates the dev shell automatically)

### Enter the development environment

```sh
nix develop
# or, with direnv:
direnv allow
```

Dev shell provides: `nixfmt`, `actionlint`, `nix-init`, `nix-update`.

### Common commands

```sh
# Validate flake configuration
nix flake check

# Build a single package
nix build .#<package-name>

# Build all packages (default = full Python environment with ipython)
nix build

# Start interactive Python session with all packages
nix run

# List available packages
nix flake show

# Open a package definition in $EDITOR
nix edit .#<package-name>

# Update flake inputs and commit lock file
nix flake update --commit-lock-file
```

### Adding a new package

```sh
./init.sh <package-name>
# Uses nix-init to scaffold from PyPI, then stages the file with git add
```

After scaffolding, review `pkgs/development/python-modules/<package-name>/default.nix` and:
- Add inter-package dependencies (packages in this repo) to the function arguments
- Verify the `meta` block (description, homepage, license, maintainer)
- Add `pythonImportsCheck`
- Set `pyproject = true` and list the build backend in `build-system`, for legacy `setup.py`
  packages too — `format = "setuptools"` is deprecated

### Updating an existing package

```sh
./update.sh <package-name>
# Runs nix-update --commit --flake <package-name>
```

---

## Package Definition Conventions

All packages live in `pkgs/development/python-modules/<package-name>/default.nix`.

### Canonical structure

```nix
{
  lib,
  python3,
  fetchPypi,       # or fetchFromGitHub
  some-mirpkg,     # inter-repo dependency declared here
}:

python3.pkgs.buildPythonPackage rec {
  pname = "package-name";
  version = "x.y.z";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-...";
  };

  # Required whenever pyproject = true. Common backends: setuptools,
  # hatchling, flit-core, poetry-core, meson-python.
  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    # runtime deps from nixpkgs
    numpy
    # plus any mirpkg deps referenced in function args
    some-mirpkg
  ];

  # Test-only deps. Never `checkInputs`, which is deprecated.
  # pytestCheckHook bundles pytest — do not list pytest separately.
  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  # Skip tests needing network, large datasets, or a GPU.
  disabledTests = [
    "test_that_downloads_a_dataset"
  ];

  # Optional: expose extras as passthru for downstream use
  passthru.optional-dependencies = with python3.pkgs; {
    tests = [ pytest pytest-cov ];
  };

  pythonImportsCheck = [ "package_name" ];

  meta = with lib; {
    description = "One-line description";
    homepage = "https://pypi.org/project/package-name/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
```

For packages whose primary artifact is an executable, use `buildPythonApplication` instead of
`buildPythonPackage` and set `meta.mainProgram` so `nix run` picks the right entry point.

### Key rules

- **Always** include `pythonImportsCheck` to validate the import.
- **Always** include a `meta` block with `description`, `homepage`, `license`, and `maintainers = with maintainers; [ carlthome ]`.
- **Always** set `pyproject = true` and declare `build-system` explicitly. `format = "setuptools"` is
  deprecated; `pyproject = true` with `build-system = [ setuptools ]` covers legacy `setup.py` packages.
- **Always** put test-only dependencies in `nativeCheckInputs`. `checkInputs` is deprecated since
  NixOS 23.05 and, unlike `nativeCheckInputs`, is not what the check phase reads.
- **Prefer** `pytestCheckHook` in `nativeCheckInputs` over a hand-written `checkPhase`. It honours
  `doCheck`, and supports `disabledTests`, `disabledTestPaths` and `pytestFlagsArray`. Put test
  environment variables in `preCheck`.
- Inter-repo package dependencies (packages within this repo) must be listed in the function argument list **and** in `dependencies`.
- nixpkgs packages are accessed via `python3.pkgs.<name>`.
- Use `fetchPypi` for PyPI releases; use `fetchFromGitHub` when tests or extra data require the full repository.
- Use `rec` on `buildPythonPackage` when `src` references `pname` or `version`.
- `fetchPypi` wants the PyPI distribution name, which is often not the `pname`. When they differ,
  pass it explicitly: `fetchPypi { pname = "pretty_midi"; inherit version; hash = ...; }`.
- Add `meta.changelog` when upstream keeps one.
- Patches go in the same directory as `default.nix` and are applied via `patches = [ ./fix-something.patch ]`.
- The `default.nix` module loader auto-discovers packages by scanning subdirectories — no manual registration needed.

### Attribute reference

| Attribute | Purpose |
|---|---|
| `pyproject = true` | Enable the PEP 517 build path (always set this) |
| `build-system` | Build-time Python tools, e.g. `setuptools`, `hatchling` |
| `dependencies` | Runtime Python deps, propagated to dependents |
| `buildInputs` | Native C libraries linked against |
| `nativeBuildInputs` | Build-time-only non-Python tools |
| `nativeCheckInputs` | Test-only deps, not propagated |
| `disabledTests` | Test names to skip under `pytestCheckHook` |
| `pytestFlagsArray` | Extra pytest flags, e.g. `[ "--ignore=tests/slow" ]` |
| `pythonImportsCheck` | Modules imported after install as a smoke test |
| `meta.mainProgram` | Entry point used by `nix run` |

### Unfree packages

`torch`, `triton`, `cudnn`, and CUDA libraries are explicitly allowed unfree in `default.nix`. Do not add new unfree packages without updating that allowlist.

---

## Code Formatting

The project uses **nixfmt** (available in the dev shell).

```sh
# Format all Nix files
nix fmt
```

CI runs `nix flake check` which validates Nix syntax. Keep all `.nix` files formatted before committing.

---

## CI/CD

### test.yaml (triggered on PRs and pushes to `main`)

1. Runs `nix flake check` to validate flake syntax.
2. Detects changed packages using path pattern `pkgs/development/python-modules/(?P<package>[^/]+)/`.
3. Builds each changed package in parallel (max 4, fail-fast disabled) with Cachix caching.
4. Per-package GitHub environment overrides are supported via `environment: ${{ matrix.package }}`.

### build.yaml

Full build triggered manually or on push to `main`. Delegates to `carlthome/workflows`.

### update.yaml

Weekly automated updates via `nix-update`. Creates commits automatically.

### flakehub.yaml

Publishes to [FlakeHub](https://flakehub.com) when a semver tag (`v?.?.?*`) is pushed.

### Cachix

Binary cache: `mirpkgs` (https://mirpkgs.cachix.org). Requires `CACHIX_AUTH_TOKEN` secret in CI.

---

## Testing

Packages validate on `nix build`. For a package with a usable test suite, reach for
`pytestCheckHook` rather than a hand-written `checkPhase`:

```nix
nativeCheckInputs = with python3.pkgs; [
  pytestCheckHook
];

preCheck = ''
  export DEFAULT_DATA_HOME=$TEMP
  export NUMBA_CACHE_DIR=$TEMP
'';

disabledTests = [
  "test_download"
];

pytestFlagsArray = [ "--ignore=tests/integration" ];
```

Several older packages here still carry a hand-written `checkPhase` (see `mirdata`); converting
them is welcome but should be done one package at a time so CI can verify each.

Tests that require network access or large datasets are typically skipped by not enabling `doCheck` or by scoping tests carefully.

---

## Common Pitfalls

- **Hash mismatches**: After changing `version`, always update the `hash` field via `nix-update` or by running `nix build` and copying the expected hash from the error.
- **Missing inter-repo deps**: If a package depends on another package in this repo, it must be listed in the function argument (not just `dependencies`). The `makeScope`/`newScope` mechanism in `pkgs/development/python-modules/default.nix` wires these up automatically.
- **Unfree packages**: Building packages that depend on `torch` requires the `config.allowUnfreePredicate` in `default.nix`. This is already configured for known CUDA/torch packages.
- **Collision errors**: `pythonEnv` is built with `ignoreCollisions = true` because some packages share files. This is expected.
- **Format**: Use `pyproject = true` for every package, legacy `setup.py` ones included, and declare the backend in `build-system`. `format = "setuptools"` still evaluates but is deprecated and warns.

---

## Overlay Usage

mirpkgs exposes a nixpkgs overlay at `overlays.default`. Downstream flakes can consume it:

```nix
inputs.mirpkgs.url = "github:carlthome/mirpkgs";

nixpkgs.overlays = [ inputs.mirpkgs.overlays.default ];
```

See `examples/flake/` for a complete working template.
