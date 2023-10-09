{ nixpkgs, system, ... }@inputs:
let
  pkgs = nixpkgs.legacyPackages.${system};
  packages = rec {
    diffq = pkgs.callPackage ./diffq.nix { };
    encodec = pkgs.callPackage ./encodec.nix { };
    jams = pkgs.callPackage ./jams.nix { };
    julius = pkgs.callPackage ./julius.nix { };
    # TODO
    #lameenc = pkgs.callPackage ./lameenc.nix { };
    stempeg = pkgs.callPackage ./stempeg.nix { };
    openunmix = pkgs.callPackage ./openunmix.nix { };
    # TODO
    #pedalboard = pkgs.callPackage ./pedalboard.nix { };
    read-version = pkgs.callPackage ./read-version.nix { };
    submitit = pkgs.callPackage ./submitit.nix { };
    treetable = pkgs.callPackage ./treetable.nix { };
    vmo = pkgs.callPackage ./vmo.nix { };
    hydra-colorlog = pkgs.callPackage ./hydra-colorlog.nix { inherit read-version; };
    msaf = pkgs.callPackage ./msaf.nix { inherit jams; inherit vmo; };
    dora-search = pkgs.callPackage ./dora-search.nix { inherit treetable; inherit submitit; };
    musdb = pkgs.callPackage ./musdb.nix { inherit stempeg; };
    museval = pkgs.callPackage ./museval.nix { inherit musdb; };
    # TODO
    #demucs = pkgs.callPackage ./demucs.nix { inherit diffq; inherit dora-search; inherit julius; inherit hydra-colorlog; inherit lameenc; inherit museval; inherit openunmix; inherit submitit; inherit treetable; };
    # TODO
    #audiocraft = pkgs.callPackage ./audiocraft.nix { inherit demucs; };
  };
  allPackages = packages: pkgs.symlinkJoin { name = "all"; paths = (builtins.attrValues packages); };
in
packages // { default = allPackages packages; }
