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
    zed-editor = mkEnableOption "enable zed editor config WIP";
  };

  config = mkIf cfg.zed-editor {
    home.packages = with pkgs-unstable; [
      zed-editor

      nerd-fonts._0xproto
      nerd-fonts.hack
      nerd-fonts.fira-code
    ];

    # fonts.packages = with pkgs-unstable.nerd-fonts; [
    #   _0xproto
    #   hack
    #   fira-code
    # ];
    # # Due to bug in Zed editor dependency user fonts aren't detected
    #   (nerdfonts.override {
    #     fonts = [
    #       "Hack"
    #       "0xProto" # HM nerdfonts aren't working in zed editor
    #       "FiraCode"
    #     ];
    #   })
  };
}
