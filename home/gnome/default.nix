{
  imports = [
    ../apps/gnome.nix
  ];

  apps = {
    gnome.core.enable = lib.mkDefault true;
    # gnome.social.enable = lib.mkDefault true;
    # image-editing.enable = lib.mkDefault true;
    # utilities.enable = lib.mkDefault true;
  };
}