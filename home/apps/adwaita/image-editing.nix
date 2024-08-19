{lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.apps.image-editing;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.apps.image-editing = {
    enable = mkEnableOption "image editing and management apps";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Image editing
      xournalpp
      darktable
      krita
      inkscape
      gimp
      hugin
      ffmpeg
      identity
      shotwell
    ];
  };
}