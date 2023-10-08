{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: with pkgs.${system}; rec {
        diffq = callPackage ./packages/diffq.nix { };
        treetable = callPackage ./packages/treetable.nix { };
        read-version = callPackage ./packages/read-version.nix { };
        hydra-colorlog = callPackage ./packages/hydra-colorlog.nix { inherit read-version; };
        dora-search = callPackage ./packages/dora-search.nix { inherit treetable; };
        julius = callPackage ./packages/julius.nix { };
        lameenc = callPackage ./packages/lameenc.nix { };
        stempeg = callPackage ./packages/stempeg.nix { };
        musdb = callPackage ./packages/musdb.nix { inherit stempeg; };
        museval = callPackage ./packages/museval.nix { inherit musdb; };
        openunmix = callPackage ./packages/openunmix.nix { };
        submitit = callPackage ./packages/submitit.nix { };
        demucs = callPackage ./packages/demucs.nix { inherit diffq; inherit dora-search; inherit hydra-colorlog; inherit julius; inherit lameenc; inherit museval; inherit openunmix; inherit submitit; inherit treetable; };
        audiocraft = callPackage ./packages/audiocraft.nix { inherit demucs; };
        default = symlinkJoin { name = "all"; paths = [ demucs audiocraft ]; };
      });

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = pkgs.${system}; };
      });
    };
}
