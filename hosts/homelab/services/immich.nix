{lib, pkgs, config, ... }:
{
  services.immich  = {
    enable = true;
    mediaLocation = "/var/lib/immich";
  }
  # for hardware accelerated video transcoding using VA-API
  # users.users.immich.extraGroups = [ "video" "render" ];

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