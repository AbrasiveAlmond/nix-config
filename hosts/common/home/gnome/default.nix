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
}