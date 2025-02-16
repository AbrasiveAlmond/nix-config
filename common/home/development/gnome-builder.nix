{
  lib,
  config,
  pkgs-unstable,
  inputs,
   ...
}: with lib;
let
  cfg = config.development;
in {

  options.development = {
    gnome-builder = mkEnableOption "enable gnome dev related stuff";

  };

  config = mkIf cfg.gnome-builder {
    home.packages = with pkgs-unstable; [
      gnome-builder
      gnome-extensions-cli
    ];

  };
}
