{
  # lib.mkIf
  dconf.settings = {
    "org/gnome/shell/extensions/happy-appy-hotkey" = {
      number = 3;
      restrict-to-current-workspace = true;
      "app-0" = "Black Box";
      "app-1" = "Files";
      "app-2" = "Firefox";
      "app-3" = "Eyedropper";
      "app-4" = "Zed";
      "app-5" = "Spotify";
      "hotkey-0" = ["<Super>t"];
      "hotkey-1" = ["<Super>f"];
      "hotkey-2" = ["<Super>b"];
      "hotkey-3" = ["<Shift><Super>c"];
      "hotkey-4" = ["<Super>z"];
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

        tile-maximize = [];
        # restore-window = ["<Super>Down"];
      };

    "org/gnome/shell/keybindings" = {
      # Toggle notification list
      toggle-message-tray = [ "<Super>v" ];
      focus-active-notification = []; # Collision
      toggle-quick-settings = [ "<Super>s" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      # managed by tiling-assistant shell extension
      # to have all behaviour in one place. see above config
      begin-resize = [ "<Super>slash" ]; # Easy to hit then use arrow keys
      activate-window-menu = [ "<Alt>h"]; # Alt help
      close = [ "<Super>c" ];
      maximize = ["<Super>m"];
      unmaximize = [];
      toggle-maximized = []; # tiling assistant does this

      panel-run-dialog = [ "<Super>r" ]; # alt-f2 is very hard


      switch-input-source = [ "<Alt><Super>space" ];
      switch-input-source-backward = [ "<Shift><Alt><Super>space" ];

      # Window Management
      ## Window Moving
      move-to-workspace-left = [ "<Shift><Super>n" ];
      move-to-workspace-right = [ "<Shift><Super>i" ];

      ## Unused Monitor Moving
      # move-to-monitor-up = [ "<Shift><Super>u" ];
      # move-to-monitor-down = [ "<Shift><Super>e" ];
      # Collision with workspace switching
      # move-to-monitor-left = [ "<Shift><Super>n" ];
      # move-to-monitor-right = [ "<Shift><Super>i" ];

      # Navigation
      ## Switch Applications
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      ## Switch Windows
      switch-windows = [ "<Alt>Tab" ];

      ## App Window Switching Direct
      # switch-group = [ "<Super>Tab" ];
      # switch-group-backward = [ "<Shift><Super>Tab" ];

      ## Workspace switching
      switch-to-workspace-left = [ "<Alt><Super>n" ];
      switch-to-workspace-right = [ "<Alt><Super>i" ];

      switch-to-workspace-last = [];

    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      next = [ "<Alt>y" ];
      play = [ "<Alt>k" ];
      previous = [ "<Alt>l" ];
      volume-down = [ "<Alt>m" ];
      volume-up = [ "<Alt>j" ];
      screensaver = [ "<Super>l" ];
      logout = [ "<Super>q" ];
      www = [];
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = 250;
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [];
    };
  };
}
