{inputs, outputs, lib, pkgs, pkgs-unstable, config, channels, ... }:
{
  imports  = [
    ./immich-nginx.nix
  ];

  services.immich  = {
    enable = true;
    host = "localhost";
    port = 2283;
    mediaLocation = "/var/lib/immich";
    openFirewall = false;

    user = "immich";
    group = "immich";
  };

  # TODO: change to "root"
  nix.settings.allowed-users = ["@wheel"];

  # for hardware accelerated video transcoding using VA-API
  users.users.immich.extraGroups = [ "video" "render" ];

  # fileSystems."/var/lib/immich" = {
  #   device = "/dev/disk/by-uuid/4f999afe-6114-4531-ba37-4bf4a00efd9e";
  #   fsType = "exfat";
  #   options = [ # If you don't have this options attribute, it'll default to "defaults" 
  #     # boot options for fstab. Search up fstab mount options you can use
  #     "users" # Allows any user to mount and unmount
  #     "nofail" # Prevent system from failing if this drive doesn't mount
  #   ];
  # };
}