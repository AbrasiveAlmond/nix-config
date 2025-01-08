{lib, ...}: {
  imports = [
    ./gnome.nix
    ./excludes.nix
  ];

  # gnome.enable = lib.mkDefault true;
  # gnome.apps.excludes.enable = lib.mkDefault true;
}