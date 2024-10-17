{
  imports = [
    ./gnome.nix
  ];

  # fix Ctrl-bspc not working in gtk apps
  # https://gitlab.gnome.org/GNOME/gtk/-/issues/570#note_742261
  dconf.settings = {
    "/org/gnome/desktop/input-sources/xkb-options" = ['lv3:ralt_switch'];
  };
}