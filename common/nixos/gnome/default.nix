{ pkgs, ... }:
{
  imports = [
    ./gnome.nix
  ];

  environment.systemPackages = with pkgs; [
    celluloid # Video player
    footage # Video editor
    switcheroo # Image converter
    eyedropper # Colour picker
    papers # PDF reader
    blackbox-terminal # better terminal
    rnote # Drawing app
    mission-center # Task manager
    gnome-graphs # Worse desmos

    # fix "Your GStreamer installation is missing a plug-in." in nautilus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

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
