{ pkgs, ... }:
{
  imports = [
    ./gnome.nix
  ];

  environment.systemPackages = with pkgs; [
    celluloid # Video player
    switcheroo # Image converter
    eyedropper # Colour picker
    papers # PDF reader
    blackbox-terminal # better terminal
    footage # Video player
    video-trimmer
    rnote # Drawing app
    mission-center # Task manager
    gnome-graphs # Worse desmos
  ];

  environment.gnome.excludePackages = with pkgs; [
    # snapshot      # Camera
    simple-scan # Document Scanner for hardware scanners
    seahorse # Password manager
    yelp # Help Viewer
    gnome-tour
    gnome-music
    gnome-contacts
    # gnome-calendar
    gnome-weather
    evince # Gnome Document viewer, superseeded by papers
    totem # Video player, outdated not adwaita. Superseeded by celluloid
  ];
}
