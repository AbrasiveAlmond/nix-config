{ lib, config, pkgs, ... }:
with lib;                      
let
  cfg = config.services.kanata;
  kanataFolder = "${../kanata-service}";
in {
  home.file.kantaconfig = {
    recursive = true;
    source = kanataFolder;
    enable = true;
  };

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
        ExecStart = (pkgs.kanata) + "/bin/kanata -c ${kanataFolder}/colemak/colemak.kbd -c ${kanataFolder}/qwerty/qwerty.kbd";
        Restart = "no";
      };
    };
  };
}