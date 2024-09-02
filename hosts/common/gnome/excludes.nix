{lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.gnome.apps.excludes;
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
      pkgs.simple-scan # Document Scanner for hardware scanners
      pkgs.seahorse # Password manager
      pkgs.yelp # Help Viewer
      pkgs.gnome-tour
      gnome-music 
      gnome-contacts
      pkgs.gnome-calendar
      gnome-weather
    ];
  };
}