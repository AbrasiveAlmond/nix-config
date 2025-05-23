let
  extsn = "org/gnome/shell/extensions/";
in
{
  ### gnomeExtensions customisation ####
  dconf.settings = {
    ${(extsn + "blur-my-shell")} = {
      sigma = 10;
      brightness = 0.8;
      noise-lightness = 0.8;
      noise-amount = 0;
    };

    ${(extsn + "vertical-workspaces")} = {
      dash-show-extensions-icon = 0;
      smooth-blur-trasitions = true;

      # Overview Background and blur
      show-bg-in-overview = true;
      overview-bg-brightness = 80;
      overview-bg-blur-sigma = 10;
      search-bg-brightness = 60;
      app-grid-bg-blur-sigma = 30;

      ws-preview-scale = 100;
      ws-thumbnail-scale = 17;
      ws-thumbnail-full = true;
      secondary-ws-thumbnail-scale = 20;
      secondary-ws-thumbnails-position = 1; # Mirror on 2nd monitor

    };

    ${(extsn + "pano")} = {
      global-shortcut = ["<Alt>v"];
      incognito-shortcut = ["<Alt><Ctrl><Super>v"];
      sync-primary = false;
      send-notification-on-copy = false;
      play-audio-on-copy = false;
      show-indicator = false;
      window-position = 3;

      item-size = 350;
      item-title-font-size = 16;
      item-title-font-family = "Cantarell";
    };

    ${(extsn + "quick-settings-tweaks")} = {
      user-removed-buttons = ["DarkModeToggle" "Notifications" "PowerProfilesToggle" "NMWiredToggle"];
      media-control-enabled = true;
      media-control-compact-mode = false;
      volume-mixer-enabled = false;
      add-dnd-quick-toggle-enabled = true;
    };

    ${(extsn + "espresso")} = {
      show-notifications = false;
    };
  };
}
