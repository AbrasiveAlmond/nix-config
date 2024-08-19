{lib, ...}: {
  imports = [
    ./gnome.nix
    ./excludes.nix
  ];

  gnomeDE.enable = lib.mkDefault true;
  gnome.apps.excludes.enable = lib.mkDefault true;
}