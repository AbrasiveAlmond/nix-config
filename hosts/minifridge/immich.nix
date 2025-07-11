{pkgs,...}: {
  services.immich  = {
    enable = true;
    package = pkgs.unstable.immich;
    host = "100.99.19.37";
    port = 2283;
    mediaLocation = "/srv/immich";
    openFirewall = false;

    user = "immich";
    group = "immich";
  };

  # If you are using Network Manager, you need to explicitly prevent it from managing container interfaces:
  # networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];

  # for hardware accelerated video transcoding using VA-API
  users.users.immich.extraGroups = [ "video" "render" ];

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # users.groups.immich = {};

  # users.users.immich = {
  #   group = "immich";
  # };
}
