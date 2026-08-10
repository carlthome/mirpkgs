{ nixpkgs, system, ... }:
let
  # Test suites in nixpkgs that broke on their own, holding back packages here
  # that are otherwise fine. Drop each entry once nixpkgs has caught up.
  fixupBrokenTests = final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (pyfinal: pyprev: {
        # The display tests compare rendered PNGs against reference images and
        # no longer match after the latest matplotlib bump.
        mir-eval = pyprev.mir-eval.overridePythonAttrs (old: {
          disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [ "test_display.py" ];
        });

        # Collection fails outright: holoviews turns warnings into errors, and
        # numpy now deprecates the generic timedelta unit it uses at import.
        holoviews = pyprev.holoviews.overridePythonAttrs { doCheck = false; };
      })
    ];
  };

  pkgs = import nixpkgs {
    system = system;
    overlays = [ fixupBrokenTests ];
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "torch"
        "triton"
        "cudnn"
        "cuda_cudart"
        "cuda_cupti"
        "cuda_cccl"
        "cuda_nvcc"
        "cuda_nvrtc"
        "cuda_nvtx"
        "libcublas"
        "libcufft"
        "libcurand"
        "libcusolver"
        "libcusparse"
        "libnvjitlink"
      ];
  };
  lib = nixpkgs.lib;
  pythonPackages = import ./pkgs/development/python-modules { inherit pkgs lib; };
  pythonEnv = pkgs.python3.buildEnv.override {
    extraLibs = (with pkgs.python3Packages; [ ipython ]) ++ builtins.attrValues pythonPackages;
    ignoreCollisions = true;
  };
in
pythonPackages // { default = pythonEnv; }
