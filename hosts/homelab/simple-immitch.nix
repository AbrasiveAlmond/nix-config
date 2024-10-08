{ config, pkgs, ... }:

{
  users.users.immich = {
    isNormalUser = true;
    group = immich;
    home = "/var/lib/containers/immich";
    createHome = true;
    description = "User for container immich";
    subUidRanges = [ { count = 65536; startUid = 615536; } ];
    subGidRanges = [ { count = 65536; startGid = 615536; } ];
    linger = true;
  };
  # Create a group for each container
  users.groups.immich = {  };

  # virtualisation.docker.enable = true;
  # virtualisation.podman.enable = true;
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  
  # add podman and podman-compose to the system
  environment.systemPackages = with pkgs; [
    podman podman-compose runc conmon skopeo slirp4netns fuse-overlayfs
  ];

  systemd.services.init-filerun-network-and-files = {
    description = "Create the network bridge for Immich";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # immich-net network
        check=$(${dockercli} network ls | grep "immich-net" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create immich-net
        else
          echo "immich-net already exists in docker"
        fi
      '';
  };
  
  # Immich
  virtualisation.oci-containers.containers = {
    immich = {
      autoStart = true;
      image = "ghcr.io/imagegenius/immich:latest";
      volumes = [
        "/immitch/config:/config"
        "/immitch/photos:/photos"
        "/immitch/config/machine-learning:/config/machine-learning"
        # /mnt/tank/Containers/Immich
      ];
      ports = [ "2283:8080" ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Pacific/Auckland"; # Change this to your timezone
        DB_HOSTNAME = "postgres14";
        DB_USERNAME = "postgres";
        DB_PASSWORD = "postgres";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "redis";
      };
      extraOptions = [ "--network=immich-net" "--gpus=all" ];
    };

    redis = {
      autoStart = true;
      image = "redis";
      ports = [ "6379:6379" ];
      extraOptions = [ "--network=immich-net" ];
    };

    postgres14 = {
      autoStart = true;
      image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
      ports = [ "5432:5432" ];
      volumes = [
        "pgdata:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_USER = "postgres";
        POSTGRES_PASSWORD = "postgres";
        POSTGRES_DB = "immich";
      };
      extraOptions = [ "--network=immich-net" ];
    };
  };

}