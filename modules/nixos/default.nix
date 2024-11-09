# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{pkgs, ...}: {
  # List your module files here
  immich = import ./immich.nix;
  # imports = [
  #   ./drivers.nix
  # ];

  services.xserver.excludePackages = [ pkgs.xterm ];
}
