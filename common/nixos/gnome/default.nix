{pkgs, lib, ...}: {
  imports = [
    ./gnome.nix
    ./excludes.nix
  ];

  nixpkgs.overlays = [
      # GNOME 46: triple-buffering-v4-46
      (final: prev: {
        mutter = prev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab  {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-47";
            hash = "sha256-6n5HSbocU8QDwuhBvhRuvkUE4NflUiUKE0QQ5DJEzwI=";
          };
        });
      })
    ];

  # gnome.enable = lib.mkDefault true;
  # gnome.apps.excludes.enable = lib.mkDefault true;
}
