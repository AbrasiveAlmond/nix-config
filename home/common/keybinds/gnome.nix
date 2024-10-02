{ 
  # lib.mkIf 
  dconf.settings = {
    "org/gnome/shell/extensions/happy-appy-hotkey" = {
      number = 3;
      restrict-to-current-workspace = true;
      "app-0" = "Console";
      "app-1" = "Files";
      "app-2" = "Firefox";
      "app-3" = "Eyedropper";
      "app-4" = "VSCodium";
      "app-5" = "Spotify";
      "hotkey-0" = ["<Super>t"];
      "hotkey-1" = ["<Super>f"];
      "hotkey-2" = ["<Super>b"];
      "hotkey-3" = ["<Shift><Super>c"];
      "hotkey-4" = ["<Super>e"];
      "hotkey-5" = ["<Super>s"];
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
        enable-tiling-popup = true; # Popup select second window to tile with
        dynamic-keybinding-behaviour = 3; # Windows like tiling behaviour
        active-window-hint = 1;

        tile-top-half =["<Super>u"];
        tile-bottom-half = ["<Super>e"];
        tile-left-half = ["<Super>n"];
        tile-right-half = ["<Super>i"];
        tile-edit-mode = ["<Super>w"];

        tile-maximize = ["<Super>m"];
        restore-window = ["<Super>Down"];
      };

    "org/gnome/desktop/wm/keybindings" = {
      # managed by tiling-assistant shell extension
      # to have all behaviour in one place. see above config
      activate-window-menu = [];
      unmaximize = [];

      close = [ "<Super>c" ];
      switch-applications = [];
      switch-applications-backward = [];
      switch-group = [ "<Super>Tab" ];
      switch-group-backward = [ "<Shift><Super>Tab" ];
      switch-input-source = [ "<Alt><Super>space" ];
      switch-input-source-backward = [ "<Shift><Alt><Super>space" ];
      toggle-maximized = [ "<Super>m" ];
      maximize = [];

      move-to-monitor-left = [ "<Shift><Super>n" ];
      move-to-monitor-right = [ "<Shift><Super>i" ];
      move-to-workspace-left = [ "<Shift><Super>u" ];
      move-to-workspace-right = [ "<Shift><Super>e" ] ;

    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      next = [ "<Alt>y" ];
      play = [ "<Alt>k" ];
      previous = [ "<Alt>l" ];
      screensaver = [];
      volume-down = [ "<Alt>m" ];
      volume-up = [ "<Alt>j" ];
      www = [];
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = 250;
    };
  };
}