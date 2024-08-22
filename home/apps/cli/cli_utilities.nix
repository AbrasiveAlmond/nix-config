{lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.apps.cli.utilities;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.apps.cli.utilities = {
    enable = mkEnableOption "utility apps";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      direnv # Dynamically load dev environments when cd'ing into folders
      # tmux
      neovim
      tree
      zoxide
    ];
  };
}