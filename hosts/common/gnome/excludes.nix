{lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.gnome.apss.excludes;
in {
  options.gnome.apps.excludes = {
    enable = mkEnableOption "Exclude useless apps";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    environment.gnome.excludePackages = with pkgs.gnome; [
      pkgs.snapshot # Camera
      simple-scan # Document Scanner for hardware scanners
      seahorse # Password manager
      yelp # Help Viewer
      pkgs.gnome-tour
      gnome-music 
      gnome-contacts
      gnome-calendar
      gnome-weather
    ];
  };
}