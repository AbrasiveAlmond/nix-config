{pkgs, ...}: {
  imports = [
    ./dconf.nix
    ./extensions.nix
    ./shortcuts.nix
  ];

  # The fix in ./dconf.nix is being undone after some amount of time.
  # so a systemd service shall do justly. 
  # https://gitlab.gnome.org/GNOME/gtk/-/issues/570#note_742261
  systemd.user.services.fixxkboption = {
    Unit.Description = "Set dconf setting that gets otherwise reset by a mysterious force";
    Install.WantedBy = [ "gnome-session-manager.target" ];

    Service = {
      ExecStart = "${pkgs.dconf}/bin/dconf reset /org/gnome/desktop/input-sources/xkb-options";
      Type = "oneshot";
      Restart = "no";
    };
  };

  home.packages = with pkgs.gnomeExtensions; lib.mkDefault [
    vertical-workspaces     # Nicer workspaces overview
    reboottouefi            # Adds uefi boot option

    happy-appy-hotkey       # Assign hotkeys to apps to focus or launch them
    dual-shock-4-battery-percentage # power level in top panel
    blur-my-shell           # Blurry shell is a needed ux improvement
    forge                   # Tiling window manager
    caffeine
    hide-top-bar
    tactile                 # Tile windows using a custom grid.
    gtile                   # literally a tiling WM
    tiling-assistant
    middle-click-to-close-in-overview # Much better.
    control-monitor-brightness-and-volume-with-ddcutil # Finally one that works!!
    burn-my-windows
  ];
}