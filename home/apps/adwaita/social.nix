{lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.gnome.apps.social;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.gnome.apps.social = {
    enable = mkEnableOption "Social media apps";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fractal       # Matrix Client
      gnome-feeds   # RSS Feeds
    ];
  };
}