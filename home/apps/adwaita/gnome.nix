{lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.apps.gnome.core;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.apps.gnome.core = {
    enable = mkEnableOption "core gnome apps";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
       # Gnome apps
      # plots
      fragments     # BitTorrent
      gnome-secrets # Passwords
      amberol       # Music player
      apostrophe    # Markdown Editor
    ];
  };
}