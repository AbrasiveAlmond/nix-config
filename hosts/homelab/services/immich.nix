({pkgs, ...}: {
  imports = [ ./caddy.nix ];
  # Only allow this to boot as a container
  # boot.isContainer = true;
  # networking.hostName = "immich-container";

  # Allow nginx through the firewall
  # networking.firewall.allowedTCPPorts = [ 80 ];
  services.immich  = {
    enable = true;
    host = "localhost";
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

  system.stateVersion = "24.11";
})