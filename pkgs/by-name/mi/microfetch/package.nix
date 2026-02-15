{
  lib,
  llvm,
  stdenv,
  stdenvAdapters,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  useMold ? stdenv.isLinux,
}: let
  stdenv =
    if useMold
    then stdenvAdapters.useMoldLinker llvm.stdenv
    else llvm.stdenv;
in
  rustPlatform.buildRustPackage.override {inherit stdenv;} (self: {
    pname = "microfetch";
    version = "0.4.13";

    src = fetchFromGitHub {
      owner = "NotAShelf";
      repo = "microfetch";
      tag = self.version;
      hash = "sha256-aJ2QuMbUM/beMD8b62AqzTNljQ8RtBNOSvj9nJfRXbA=";
    };

    cargoHash = "sha256-vGvpjRJr4ez322JWUwboVml22vnRVRlwpZ9W4F5wATA=";
    enableParallelBuilding = true;
    buildNoDefaultFeatures = true;
    passthru.updateScript = nix-update-script {};

    #Only set RUSTFLAGS for mold if useMold is enabled
    env = lib.optionalAttrs useMold {
      CARGO_LINKER = "clang";
      RUSTFLAGS = "-C link-arg=-fuse-ld=mold";
    };

    meta = {
      description = "Microscopic fetch script in Rust, for NixOS systems";
      homepage = "https://github.com/NotAShelf/microfetch";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        nydragon
        NotAShelf
      ];
      mainProgram = "microfetch";
      platforms = lib.platforms.linux;
    };
  })
