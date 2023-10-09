final: prev: rec {
  diffq = final.callPackage ./packages/diffq.nix { };
  encodec = final.callPackage ./packages/encodec.nix { };
  jams = final.callPackage ./packages/jams.nix { };
  julius = final.callPackage ./packages/julius.nix { };
  # TODO
  #lameenc = final.callPackage ./packages/lameenc.nix { };
  stempeg = final.callPackage ./packages/stempeg.nix { };
  openunmix = final.callPackage ./packages/openunmix.nix { };
  # TODO
  #pedalboard = final.callPackage ./packages/pedalboard.nix { };
  read-version = final.callPackage ./packages/read-version.nix { };
  submitit = final.callPackage ./packages/submitit.nix { };
  treetable = final.callPackage ./packages/treetable.nix { };
  vmo = final.callPackage ./packages/vmo.nix { };
  hydra-colorlog = final.callPackage ./packages/hydra-colorlog.nix { inherit read-version; };
  msaf = final.callPackage ./packages/msaf.nix { inherit jams; inherit vmo; };
  dora-search = final.callPackage ./packages/dora-search.nix { inherit treetable; inherit submitit; };
  musdb = final.callPackage ./packages/musdb.nix { inherit stempeg; };
  museval = final.callPackage ./packages/museval.nix { inherit musdb; };
  # TODO
  #demucs = final.callPackage ./packages/demucs.nix { inherit diffq; inherit dora-search; inherit julius; inherit hydra-colorlog; inherit lameenc; inherit museval; inherit openunmix; inherit submitit; inherit treetable; };
  # TODO
  #audiocraft = final.callPackage ./packages/audiocraft.nix { inherit demucs; };
}
