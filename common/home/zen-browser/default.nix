{ config, inputs, ... }:
let
  profile-name = "quinnieboi";
  zen-profile = ".zen/${profile-name}/chrome";
in {
  home.file."${zen-profile}/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  # home.file."${zen-profile}/customChrome.css".source = ./chrome/customChrome.css;
  # home.file."${zen-profile}/customContent.css".source = ./chrome/customContent.css;
  # home.file."${zen-profile}/gnome-sidebery.css".source = ./chrome/gnome-sidebery.css;

}
