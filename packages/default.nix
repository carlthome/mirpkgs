{ nixpkgs, system, ... }@inputs:
let
  pkgs = nixpkgs.legacyPackages.${system};
  packages = rec {
    diffq = pkgs.callPackage ./diffq.nix { };
    treetable = pkgs.callPackage ./treetable.nix { };
    read-version = pkgs.callPackage ./read-version.nix { };
    hydra-colorlog = pkgs.callPackage ./hydra-colorlog.nix { inherit read-version; };
    dora-search = pkgs.callPackage ./dora-search.nix { inherit treetable; };
    julius = pkgs.callPackage ./julius.nix { };
    lameenc = pkgs.callPackage ./lameenc.nix { };
    stempeg = pkgs.callPackage ./stempeg.nix { };
    musdb = pkgs.callPackage ./musdb.nix { inherit stempeg; };
    museval = pkgs.callPackage ./museval.nix { inherit musdb; };
    openunmix = pkgs.callPackage ./openunmix.nix { };
    submitit = pkgs.callPackage ./submitit.nix { };
    demucs = pkgs.callPackage ./demucs.nix { inherit diffq; inherit dora-search; inherit hydra-colorlog; inherit julius; inherit lameenc; inherit museval; inherit openunmix; inherit submitit; inherit treetable; };
    audiocraft = pkgs.callPackage ./audiocraft.nix { inherit demucs; };
  };
  allPackages = packages: pkgs.symlinkJoin { name = "all"; paths = (builtins.attrValues packages); };
in
packages // { default = allPackages packages; }
