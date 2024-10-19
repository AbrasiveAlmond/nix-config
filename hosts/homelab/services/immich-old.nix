{ config, lib, pkgs, ... }:
with lib; {
  options.immitch.services.itchy.enable =
    mkEnableOption "Activates immitch server via itchy user";

  config = mkIf config.immitch.services.itchy.enable {
    # Define a user account per service.
    users.users.itchy = {
      description = "immitch host";
      isSystemUser = true;
      initialPassword = "changeme";
      
      createHome = true;
      home = "/srv/immitch/itchy";

      group = "immitch";
      extraGroups = [ "keys" ];
    };

    deployment.keys.itchy = {
      text = builtins.readFile ./secrets/itchy.env;
      user = "itchy";
      group = "immitch";
      permissions = "0640";
    };

    systemd.services.itchy = {
      wantedBy = [ "multi-user.target" ];
      after = [ "itchy-key.service" ];
      wants = [ "itchy-key.service" ];

      serviceConfig = {
        User = "itchy";
        Group = "immitch";
        Restart = "on-failure"; # automatically restart the server when it dies
        WorkingDirectory = "/srv/immitch/itchy";
        RestartSec = "30s";
      };

      script = let itchy = pkgs.immitch.withinbot;
      in ''
        stuff with docker i suppose
      '';
    };
  };
}
