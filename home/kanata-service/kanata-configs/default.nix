{ lib, config, ... }:
with lib;                      
let
  cfg = config.services.kanata;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.kanata = {
    enable = mkEnableOption "enable kanata service";
  };

  config = mkIf cfg.enable {
    systemd.user.services.kanata = {
      Unit.Description = "Kanata Daemon";
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "exec";
        ExecStartPre="/run/current-system/sw/bin/modprobe uinput"; # May not be necessary
        ExecStart = (pkgs.kanata) + "/bin/kanata -c ./colemak/colemak.kbd -c ./qwerty/qwerty.kbd";
        Restart = "no";
      };
      
    };

  };
}