{ config, lib, pkgs, ... }:
with lib.hm.gvariant;
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
    hide-top-bar
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

#     "/org/gnome/shell/extensions/" = {
#       "alphabetical-app-grid" = {
#         folder-order-position = "start";
#       };

#       "blur-my-shell" = {
#         brightness = 0.8;
#         hacks-level = 1;
#         noise-amount = 0;
#         noise-lightness = 0.8;
#         settings-version = 2;
#         sigma = 10;
#       };

#       "blur-my-shell/appfolder" = {
#         blur = false;
#         brightness = 0.8;
#         sigma = 10;
#       };

#       "blur-my-shell/applications" = {
#         blur = false;
#         blur-on-overview = false;
#         opacity = 231;
#         whitelist = [];
#       };

#       "blur-my-shell/dash-to-dock" = {
#         blur = true;
#         brightness = 0.8;
#         override-background = false;
#         sigma = 10;
#         static-blur = true;
#         style-dash-to-dock = 0;
#       };

#       "blur-my-shell/overview" = {
#         blur = false;
#       };

#       "blur-my-shell/panel" = {
#         brightness = 0.8;
#         sigma = 10;
#       };

#       "blur-my-shell/window-list" = {
#         brightness = 0.8;
#         sigma = 10;
#       };

#       "caffeine" = {
#         countdown-timer = 15;
#         indicator-position-max = 2;
#         toggle-shortcut = [ "" ];
#       };

#       "clipboard-indicator" = {
#         clear-on-boot = true;
#         toggle-menu = [ "<Shift><Control>v" ];
#       };

#       "dim-background-windows" = {
#         dimming-enabled = true;
#         toggle-shortcut = [ "<Super>g" ];
#       };

#       "display-brightness-ddcutil" = {
#         allow-zero-brightness = true;
#         button-location = 0;
#         ddcutil-binary-path = "/nix/store/y36ihgdxpl3qrlzi7i2kx2pb6igpj2f9-ddcutil-2.1.4/bin/ddcutil";
#         ddcutil-queue-ms = 130.0;
#         ddcutil-sleep-multiplier = 116.0;
#         decrease-brightness-shortcut = [ "<Control>Home" ];
#         disable-display-state-check = true;
#         hide-system-indicator = false;
#         increase-brightness-shortcut = [ "<Control>End" ];
#         position-system-indicator = 0.0;
#         position-system-menu = 3.0;
#         show-all-slider = false;
#         step-change-keyboard = 4.0;
#         verbose-debugging = false;
#       };

#       "espresso" = {
#         has-battery = false;
#         show-indicator = true;
#         show-notifications = false;
#         user-enabled = false;
#       };

#       "forge" = {
#         css-last-update = lib.mkUint32 37;
#         focus-border-toggle = true;
#         tiling-mode-enabled = false;
#         window-gap-hidden-on-single = false;
#         window-gap-size = mkUint32 4;
#       };

#       "forge/keybindings" = {
#         con-split-horizontal = [ "<Super>z" ];
#         con-split-layout-toggle = [ "<Super>g" ];
#         con-split-vertical = [ "<Super>v" ];
#         con-stacked-layout-toggle = [ "<Shift><Super>s" ];
#         con-tabbed-layout-toggle = [ "<Shift><Super>t" ];
#         con-tabbed-showtab-decoration-toggle = [ "<Control><Alt>y" ];
#         focus-border-toggle = [ "<Super>x" ];
#         prefs-tiling-toggle = [ "<Super>w" ];
#         window-focus-down = [ "<Super>e" ];
#         window-focus-left = [ "<Super>n" ];
#         window-focus-right = [ "<Super>o" ];
#         window-focus-up = [ "<Super>i" ];
#         window-gap-size-decrease = [ "<Control><Super>minus" ];
#         window-gap-size-increase = [ "<Control><Super>plus" ];
#         window-move-down = [ "<Shift><Super>e" ];
#         window-move-left = [ "<Shift><Super>n" ];
#         window-move-right = [ "<Shift><Super>o" ];
#         window-move-up = [ "<Shift><Super>i" ];
#         window-resize-bottom-decrease = [ "<Shift><Control><Super>i" ];
#         window-resize-bottom-increase = [ "<Control><Super>u" ];
#         window-resize-left-decrease = [ "<Shift><Control><Super>o" ];
#         window-resize-left-increase = [ "<Control><Super>y" ];
#         window-resize-right-decrease = [ "<Shift><Control><Super>y" ];
#         window-resize-right-increase = [ "<Control><Super>o" ];
#         window-resize-top-decrease = [ "<Shift><Control><Super>u" ];
#         window-resize-top-increase = [ "<Control><Super>i" ];
#         window-snap-center = [ "<Control><Alt>c" ];
#         window-snap-one-third-left = [ "<Control><Alt>d" ];
#         window-snap-one-third-right = [ "<Control><Alt>g" ];
#         window-snap-two-third-left = [ "<Control><Alt>e" ];
#         window-snap-two-third-right = [ "<Control><Alt>t" ];
#         window-swap-down = [ "<Control><Super>j" ];
#         window-swap-last-active = [ "<Super>Return" ];
#         window-swap-left = [ "<Control><Super>h" ];
#         window-swap-right = [ "<Control><Super>l" ];
#         window-swap-up = [ "<Control><Super>k" ];
#         window-toggle-always-float = [ "<Shift><Super>c" ];
#         window-toggle-float = [ "<Super>c" ];
#         workspace-active-tile-toggle = [ "<Shift><Super>w" ];
#       };

#       "gtile" = {
#         auto-close = true;
#         window-spacing = 50;
#       };

#       "happy-appy-hotkey" = {
#         app-0 = "Console";
#         app-1 = "Files";
#         app-2 = "Firefox";
#         app-3 = "Eyedropper";
#         hotkey-0 = [ "<Super>t" ];
#         hotkey-1 = [ "<Super>f" ];
#         hotkey-2 = [ "<Super>b" ];        hotkey-3 = [ "<Shift><Super>c" ];
#         number = 3;
#         restrict-to-current-workspace = true;
#       };

#       "hidetopbar" = {
#         enable-active-window = false;
#         enable-intellihide = true;
#         keep-round-corners = false;
#         mouse-sensitive = true;
#         mouse-sensitive-fullscreen-window = true;
#       };

#       "pano" = {
#         global-shortcut = [ "<Alt>v" ];
#         incognito-shortcut = [ "<Alt><Ctrl><Super>v" ];
#         is-in-incognito = true;
#         item-date-font-family = "Source Sans 3";
#         item-date-font-size = 11;
#         item-size = 350;
#         item-title-font-family = "Cantarell";
#         item-title-font-size = 16;
#         play-audio-on-copy = false;
#         send-notification-on-copy = false;
#         show-indicator = false;
#         sync-primary = false;
#         wiggle-indicator = true;
#         window-position = 3;
#       };

#       "quick-settings-tweaks" = {
#         add-dnd-quick-toggle-enabled = true;
#         add-unsafe-quick-toggle-enabled = false;
#         input-always-show = false;
#         input-show-selected = false;
#         last-unsafe-state = false;
#         list-buttons = "[{\"name\":\"SystemItem\",\"title\":null,\"visible\":true},{\"name\":\"OutputStreamSlider\",\"title\":null,\"visible\":true},{\"name\":\"InputStreamSlider\",\"title\":null,\"visible\":false},{\"name\":\"BrightnessItem\",\"title\":null,\"visible\":false},{\"name\":\"NMWiredToggle\",\"title\":\"Wired\",\"visible\":true},{\"name\":\"NMWirelessToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMModemToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMBluetoothToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMVpnToggle\",\"title\":null,\"visible\":false},{\"name\":\"BluetoothToggle\",\"title\":\"Bluetooth\",\"visible\":false},{\"name\":\"PowerProfilesToggle\",\"title\":\"Power Mode\",\"visible\":true},{\"name\":\"NightLightToggle\",\"title\":\"Night Light\",\"visible\":true},{\"name\":\"DarkModeToggle\",\"title\":\"Dark Style\",\"visible\":true},{\"name\":\"KeyboardBrightnessToggle\",\"title\":\"Keyboard\",\"visible\":false},{\"name\":\"RfkillToggle\",\"title\":\"Aeroplane Mode\",\"visible\":false},{\"name\":\"RotationToggle\",\"title\":\"Auto Rotate\",\"visible\":false},{\"name\":\"DndQuickToggle\",\"title\":\"Do Not Disturb\",\"visible\":true},{\"name\":\"BackgroundAppsToggle\",\"title\":\"No Background Apps\",\"visible\":false},{\"name\":\"MediaSection\",\"title\":null,\"visible\":false},{\"name\":\"Notifications\",\"title\":null,\"visible\":true}]";
#         media-control-compact-mode = false;
#         media-control-enabled = true;
#         notifications-hide-when-no-notifications = true;
#         notifications-integrated = true;
#         notifications-position = "bottom";
#         output-show-selected = false;
#         user-removed-buttons = [ "DarkModeToggle" "Notifications" "PowerProfilesToggle" "NMWiredToggle" ];
#         volume-mixer-check-description = false;
#         volume-mixer-enabled = false;
#         volume-mixer-position = "top";
#         volume-mixer-show-description = false;
#         volume-mixer-show-icon = false;
#         volume-mixer-use-regex = false;
#       };

#       "tactile" = {
#         show-tiles = [ "<Super>Return" ];
#         tile-1-1 = [ "r" ];
#         tile-2-1 = [ "s" ];
#         tile-3-1 = [ "t" ];
#         tile-3-2 = [ "d" ];
#       };

#       "tiling-assistant" = {
#         activate-layout0 = [];
#         activate-layout1 = [];
#         activate-layout2 = [];
#         activate-layout3 = [];
#         active-window-hint = 1;
#         active-window-hint-color = "rgb(53,132,228)";
#         auto-tile = [];
#         center-window = [];
#         debugging-free-rects = [];
#         debugging-show-tiled-rects = [];
#         default-move-mode = 0;
#         dynamic-keybinding-behavior = 2;
#         dynamic-keybinding-behaviour = 2;
#         enable-tiling-popup = true;
#         import-layout-examples = false;
#         last-version-installed = 47;
#         restore-window = [ "<Super>Down" ];
#         search-popup-layout = [];
#         tile-bottom-half = [ "<Super>e" ];
#         tile-bottom-half-ignore-ta = [];
#         tile-bottomleft-quarter = [];
#         tile-bottomleft-quarter-ignore-ta = [];
#         tile-bottomright-quarter = [];
#         tile-bottomright-quarter-ignore-ta = [];
#         tile-edit-mode = [ "<Super>w" ];
#         tile-left-half = [ "<Super>n" ];
#         tile-left-half-ignore-ta = [];
#         tile-maximize = [ "<Super>Up" "<Super>KP_5" ];
#         tile-maximize-horizontally = [];
#         tile-maximize-vertically = [];
#         tile-right-half = [ "<Super>i" ];
#         tile-right-half-ignore-ta = [];
#         tile-top-half = [ "<Super>u" ];
#         tile-top-half-ignore-ta = [];
#         tile-topleft-quarter = [];
#         tile-topleft-quarter-ignore-ta = [];
#         tile-topright-quarter = [];
#         tile-topright-quarter-ignore-ta = [];
#         toggle-always-on-top = [];
#         toggle-tiling-popup = [];
#         window-gap = 2;
#       };

#       "vertical-workspaces" = {
#         app-favorites-module = true;
#         app-grid-bg-blur-sigma = 30;
#         center-app-grid = false;
#         center-dash-to-ws = false;
#         dash-bg-gs3-style = true;
#         dash-max-icon-size = 48;
#         dash-module = true;
#         dash-position = 1;
#         dash-position-adjust = 0;
#         dash-show-extensions-icon = 0;
#         dash-show-recent-files-icon = 1;
#         dash-show-windows-icon = 0;
#         layout-module = false;
#         osd-position = 6;
#         overlay-key-secondary = 1;
#         overview-bg-blur-sigma = 10;
#         overview-bg-brightness = 80;
#         overview-esc-behavior = 0;
#         panel-position = 0;
#         panel-visibility = 0;
#         search-bg-brightness = 60;
#         secondary-ws-preview-scale = 100;
#         secondary-ws-preview-shift = false;
#         secondary-ws-thumbnail-scale = 20;
#         secondary-ws-thumbnails-position = 1;
#         show-bg-in-overview = true;
#         smooth-blur-transitions = true;
#         smooth-blur-trasitions = true;
#         ws-max-spacing = 350;
#         ws-preview-scale = 100;
#         ws-sw-popup-v-position = 50;
#         ws-thumbnail-full = true;
#         ws-thumbnail-scale = 17;
#         ws-thumbnail-scale-appgrid = 13;
#         ws-thumbnails-full = true;
#       };
#     };
#   };
# }
    ### gnomeExtensions customisation ####
#  dconf.settings = {
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
        tile-edit-mode = ["<Super>w"];
      };

      ${(extsn + "display-brightness-ddcutil")} = {
        ddcutil-binary-path = (pkgs.ddcutil) + "/bin/ddcutil";
        verbose-debugging = false;
        step-change-keyboard = 4.0;
        increase-brightness-shortcut = ["<Control>End"];
        decrease-brightness-shortcut = ["<Control>Home"];
      };
    };
  # };
}
