{ config, lib, pkgs, ... }:
let
  extsn = "org/gnome/shell/extensions/";
in
{
  home.packages = with pkgs.gnomeExtensions; [
    vertical-workspaces    # Nicer workspaces overview
    reboottouefi           # Adds uefi boot option

    happy-appy-hotkey      # Assign hotkeys to apps to focus or launch them
    dual-shock-4-battery-percentage # power level in top panel
    blur-my-shell          # Blurry shell is a needed ux improvement
    forge                 # Tiling window manager
    caffeine
    tactile # Tile windows using a custom grid.
    gtile # literally a tiling WM
    tiling-assistant
    middle-click-to-close-in-overview # Much better.
    
    brightness-control-using-ddcutil

    clipboard-indicator-2
    burn-my-windows

    
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "vertical-workspaces@G-dH.github.com"
        "reboottouefi@ubaygd.com"
        "blur-my-shell@aunetx"
        "happy-appy-hotkey@jqno.nl"
        #"ds4battery@slie.ru"
        "quick-settings-tweaks@qwreey"
        "caffeine@patapon.info"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "tiling-assistant@leleat-on-github"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        # "display-brightness-ddcutil@themightydeity.github.com"
      ];
    };
  };

  #### gnomeExtensions customisation ####
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

      ${(extsn + "happy-appy-hotkey")} = {
        number = 3;
        restrict-to-current-workspace = true;
        "app-0" = "Console";
        "app-1" = "Files";
        "app-2" = "Firefox";
        "app-3" = "Eyedropper";
        "hotkey-0" = ["<Super>t"];
        "hotkey-1" = ["<Super>f"];
        "hotkey-2" = ["<Super>b"];
        "hotkey-3" = ["<Shift><Super>c"];
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

      ${(extsn + "alphabetical-app-grid")} = {
        folder-order-position = "start";
      };

      ${(extsn + "tiling-assistant")} = {
        enable-tiling-popup = true; # Select second window to tile with
        dynamic-keybinding-behaviour = 2;
        tile-top-half =["<Super>u"];
        tile-bottom-half = ["<Super>e"];
        tile-left-half = ["<Super>n"];
        tile-right-half = ["<Super>i"];
      };

      ${(extsn + "display-brightness-ddcutil")} = {
        ddcutil-binary-path = (pkgs.ddcutil) + "/bin/ddcutil";
        verbose-debugging = false;
        step-change-keyboard = 4.0;
        increase-brightness-shortcut = ["<Control>End"];
        decrease-brightness-shortcut = ["<Control>Home"];
      };
    };
}
