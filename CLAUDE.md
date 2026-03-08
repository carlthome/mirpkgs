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

### Current packages (54 total)

`aeiou`, `alias-free-torch`, `argbind`, `audiocraft`, `audioscrape`, `auraloss`, `dali-dataset`, `demucs`, `descript-audio-codec`, `descript-audiotools`, `diffq`, `dora-search`, `einops-exts`, `einx`, `ema-pytorch`, `encodec`, `flashy`, `hydra-colorlog`, `hyper-connections`, `jams`, `julius`, `laion-clap`, `lameenc`, `local-attention`, `madmom`, `mediapipe`, `mido`, `mirdata`, `msaf`, `musdb`, `museval`, `music21`, `opencv-contrib-python`, `openunmix`, `pedalboard`, `prefigure`, `pretty-midi`, `pyloudnorm`, `pystoi`, `pytest-runner`, `randomname`, `read-version`, `soundcloud-lib`, `stable-audio-tools`, `stempeg`, `submitit`, `torch-stoi`, `torchtext`, `treetable`, `v-diffusion-pytorch`, `vector-quantize-pytorch`, `vmo`, `x-transformers`

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
- Verify the `meta` block (description, homepage, changelog, license, maintainer)
- Add `pythonImportsCheck`
- Set `pyproject = true` and populate `build-system` with the required build backends
- Replace `format = "setuptools"` (deprecated) with `pyproject = true` + `build-system = [ setuptools ]`
- Replace any `checkInputs` (deprecated) with `nativeCheckInputs` containing `pytestCheckHook`

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

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "package-name";
  version = "x.y.z";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-...";
  };

  # Always specify the build backend explicitly when pyproject = true.
  # Common values: setuptools, hatchling, flit-core, poetry-core, meson-python
  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    # runtime deps from nixpkgs
    numpy
    # plus any mirpkg deps referenced in function args
    some-mirpkg
  ];

  # Use pytestCheckHook instead of a custom checkPhase.
  # pytest itself is bundled with pytestCheckHook — do not add it separately.
  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  # Selectively disable tests that require network, large datasets, or are flaky.
  disabledTests = [
    "test_that_requires_network"
  ];

  # Optional: expose extras as passthru for downstream use
  passthru.optional-dependencies = with python3.pkgs; {
    tests = [ pytest-cov ];
  };

  pythonImportsCheck = [ "package_name" ];

  meta = with lib; {
    description = "One-line description";
    homepage = "https://pypi.org/project/package-name/";
    # Include changelog when available (especially for GitHub-sourced packages)
    changelog = "https://github.com/owner/repo/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
})
```

For CLI tools/applications (packages that install executables as the primary artifact), use `buildPythonApplication` instead of `buildPythonPackage` and add `mainProgram`:

```nix
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "my-tool";
  ...
  meta = with lib; {
    ...
    mainProgram = "my-tool";
  };
})
```

### Key rules

- **Always** use `pyproject = true` — even for legacy `setup.py` packages (`pyproject = true` falls back to setuptools). Never use `format = "setuptools"` (deprecated).
- **Always** declare `build-system` explicitly when using `pyproject = true`. Common backends: `setuptools`, `hatchling`, `flit-core`, `poetry-core`, `meson-python`.
- **Always** include `pythonImportsCheck` to validate the import.
- **Always** include a `meta` block with `description`, `homepage`, `license`, and `maintainers = with maintainers; [ carlthome ]`.
- **Always** use `nativeCheckInputs` for test dependencies — **never** `checkInputs` (deprecated since NixOS 23.05). Test-only deps are not propagated to dependents.
- **Prefer** `pytestCheckHook` over a custom `checkPhase`. It handles `doCheck`/`doInstallCheck` correctly and supports `disabledTests`, `pytestFlagsArray`, etc.
- **Prefer** the `finalAttrs` pattern (`buildPythonPackage (finalAttrs: { ... })`) to allow self-referencing via `inherit (finalAttrs) pname version` in `src` and `meta.changelog`.
- Inter-repo package dependencies (packages within this repo) must be listed in the function argument list **and** in `dependencies`.
- nixpkgs packages are accessed via `python3.pkgs.<name>`.
- Use `fetchPypi` for PyPI releases; use `fetchFromGitHub` when tests or extra data require the full repository.
- When the PyPI distribution name uses underscores (e.g., `stable_audio_tools`) but the package `pname` uses hyphens, pass `pname` explicitly to `fetchPypi`: `fetchPypi { pname = "stable_audio_tools"; inherit version; hash = ...; }`.
- Use `rec` on `buildPythonPackage` only when not using `finalAttrs` and `src` references `pname` or `version`. Prefer `finalAttrs` for new packages.
- Patches go in the same directory as `default.nix` and are applied via `patches = [ ./fix-something.patch ]`.
- Use `lib.optionals pkgs.stdenv.isDarwin [ ... ]` / `lib.optionals pkgs.stdenv.isLinux [ ... ]` for platform-specific dependencies.
- The `default.nix` module loader auto-discovers packages by scanning subdirectories — no manual registration needed.
- Add `meta.changelog` when the upstream project maintains one (particularly for GitHub-hosted packages).

### Attribute reference

| Attribute | Purpose |
|---|---|
| `pyproject = true` | Enable PEP 517/518 build (always set this) |
| `build-system` | Build-time Python tools (e.g., `setuptools`, `hatchling`) |
| `dependencies` | Runtime Python deps (propagated to dependents) |
| `buildInputs` | Native/C system libraries needed at build or runtime |
| `nativeBuildInputs` | Build-time-only non-Python executables |
| `nativeCheckInputs` | Test-only deps (`pytestCheckHook`, etc.) — not propagated |
| `disabledTests` | List of test names to skip when using `pytestCheckHook` |
| `pytestFlagsArray` | Extra flags passed to pytest (e.g., `[ "--ignore=tests/slow" ]`) |
| `passthru.optional-dependencies` | Expose pip extras for downstream use |
| `pythonImportsCheck` | Module names validated by importing after install |
| `meta.mainProgram` | Entry point name for `nix run` (use with `buildPythonApplication`) |
| `meta.changelog` | Link to upstream changelog |

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

Packages validate on `nix build`. For packages with a test suite, use `pytestCheckHook` in `nativeCheckInputs`:

```nix
nativeCheckInputs = with python3.pkgs; [
  pytestCheckHook
];

# Skip tests that need network access, large datasets, or are known-flaky:
disabledTests = [
  "test_download"
  "test_requires_gpu"
];

# Pass additional pytest flags:
pytestFlagsArray = [ "--ignore=tests/integration" ];

# Set env vars needed by tests:
preCheck = ''
  export DEFAULT_DATA_HOME=$TEMP
  export NUMBA_CACHE_DIR=$TEMP
'';
```

`pytestCheckHook` bundles pytest — do not add `pytest` separately to `nativeCheckInputs`. Tests run in `installCheckPhase` (after install), so the installed package is on the path rather than the source tree.

For packages where running tests is impractical (large data downloads, GPU requirements), omit `nativeCheckInputs` and rely on `pythonImportsCheck` as the minimal smoke test.

---

## Common Pitfalls

- **Hash mismatches**: After changing `version`, always update the `hash` field via `nix-update` or by running `nix build` and copying the expected hash from the error.
- **Missing inter-repo deps**: If a package depends on another package in this repo, it must be listed in the function argument (not just `dependencies`). The `makeScope`/`newScope` mechanism in `pkgs/development/python-modules/default.nix` wires these up automatically.
- **Unfree packages**: Building packages that depend on `torch` requires the `config.allowUnfreePredicate` in `default.nix`. This is already configured for known CUDA/torch packages.
- **Collision errors**: `pythonEnv` is built with `ignoreCollisions = true` because some packages share files. This is expected.
- **Deprecated `format = "setuptools"`**: Replace with `pyproject = true` + `build-system = [ setuptools ]`. The `format` attribute is no longer recognised in current nixpkgs and will produce an error.
- **Deprecated `checkInputs`**: Replace with `nativeCheckInputs`. `checkInputs` was removed around NixOS 23.05; using it has no effect and silently omits test dependencies.
- **Missing `build-system`**: When `pyproject = true`, failing to declare `build-system` means the package will be built with no build backend — typically resulting in a wheel-build error. Always specify the backend (e.g., `setuptools`, `hatchling`, `flit-core`).
- **PyPI name normalisation**: PyPI distribution names may use underscores while `pname` uses hyphens. Pass the exact PyPI name to `fetchPypi`: `fetchPypi { pname = "my_package"; inherit version; hash = ...; }`.
- **`buildPythonApplication` vs `buildPythonPackage`**: Use `buildPythonApplication` for packages whose primary artifact is a CLI tool. It produces a non-propagating derivation and pairs with `meta.mainProgram`.

---

## Overlay Usage

mirpkgs exposes a nixpkgs overlay at `overlays.default`. Downstream flakes can consume it:

```nix
inputs.mirpkgs.url = "github:carlthome/mirpkgs";

nixpkgs.overlays = [ inputs.mirpkgs.overlays.default ];
```

See `examples/flake/` for a complete working template.
