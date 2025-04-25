{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./excludes.nix
  ];
  # nixpkgs.overlays = [
  # (final: prev: {
  #    mutter = prev.mutter.overrideAttrs (old: {
  #      src = pkgs.fetchFromGitLab  {
  #        domain = "gitlab.gnome.org";
  #        owner = "vanvugt";
  #        repo = "mutter";
  #        rev = "triple-buffering-v4-47";
  #        hash = "sha256-6n5HSbocU8QDwuhBvhRuvkUE4NflUiUKE0QQ5DJEzwI=";
  #      };

  #      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
  #        pkgs.cmake  # just in case it's also needed
  #      ];

  #    });
  #    })
  # ];
  # gnome.enable = lib.mkDefault true;
  # gnome.apps.excludes.enable = lib.mkDefault true;
}
