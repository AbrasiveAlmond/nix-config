{lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.apps.utilities;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.apps.utilities = {
    enable = mkEnableOption "utility apps";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      warp 
      pika-backup

      # brightness
      ddcui       # boot-kernel module "ddcci_backlight" for brightness control
      ddcutil

      # pavucontrol # When it is running it disables power_saving / auto_suspend / whatever makes audio take 5s to cut in
      pwvucontrol # Better looking - same functionality

      # Keyboard remapping
      kanata

      gnome-builder
      gnome-extensions-cli

      vscodium
      direnv # Dynamically load dev environments when cd'ing into folders
      tmux
      neovim
      tree
      zoxide
    ];
  };
}