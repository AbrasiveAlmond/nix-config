{ config, pkgs, ... }:

{
  # add podman and podman-compose to the system
  environment.systemPackages = with pkgs; [
    podman podman-compose runc conmon skopeo slirp4netns fuse-overlayfs
  ];
}