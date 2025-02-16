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
    cli-tools = mkEnableOption "enable coding/terminal related stuff";

  };

  config = mkIf cfg.cli-tools {
    home.packages = with pkgs-unstable; [
        libsecret
        git-credential-oauth
        tree
        nil
        vivid
    ];

  };
}
