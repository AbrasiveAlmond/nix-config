{ lib, config, pkgs, ... }:
with lib;                      
let
  cfg = config.services.kanata;
  kanataFolder = "${../kanata-service}";
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.kanata = {
    enable = mkEnableOption "enable kanata service";
  };

  config = mkIf cfg.enable {
    systemd.user.services.kanata = {
      Unit.Description = "Kanata Daemon";
      Install.WantedBy = [ "gnome-session-manager.target" ];

      Service = {
        # Make configuration split between multiple files work
        WorkingDirectory = kanataFolder;

        Type = "exec";
        ExecStartPre="/run/current-system/sw/bin/modprobe uinput"; # May not be necessary
        # ExecStartPre = "echo ${kanataFolder}";
        ExecStart = (pkgs.kanata) + "/bin/kanata -c ${kanataFolder}/./colemak/colemak.kbd -c ${kanataFolder}/./qwerty/qwerty.kbd";
        # ExecStart = "ls ";
        Restart = "no";
      };
    };
  };
}