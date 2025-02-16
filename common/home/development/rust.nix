{
  lib,
  config,
  pkgs-unstable,
  inputs,
   ...
}: with lib;
let
  cfg = config.development;
in {

  options.development = {
    rust = mkEnableOption "enable rust development stuff";
  };

  config = mkIf cfg.rust {
    home.packages = with pkgs-unstable; [
        # Now Handled by rust-devshells flake
        # https://github.com/AbrasiveAlmond/rust-dev-flake
        # cargo
        # gcc
        # rustc
        rust-analyzer
        # rustup # collides with cargo
    ];
    
    nix.registry = {
        rust.flake = inputs.rust-devShells;
    };
  };
}
