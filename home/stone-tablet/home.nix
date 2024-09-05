{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    #outputs.homeManagerModules
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # ../apps
    ../common/kanata-service/default.nix
    ../common/gnome
    ../common/programs/cli
    ../common/programs/firefox
  ];

  home.packages = with pkgs; [
       # Gnome apps
      plots         # Worse desmos
      gnome-secrets # Passwords
      apostrophe    # Markdown Editor
      eyedropper    # Colour picker

      gnome-feeds   # RSS Feeds

      # Utilities
      warp          # File sharing tool

      # Keyboard remapping
      kanata

      tmux
      neovim
      tree
      zoxide
      git
      
      # just in case it is more performant
      ungoogled-chromium
  ];

  # accessed via home-manager modules
  services.kanata.enable = true;

  nixpkgs = {
    # You can add overlays here
    #overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
     # outputs.overlays.additions
      #outputs.overlays.modifications
      #outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    #];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      #allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["spotify"];
    };
  };

  # TODO: Set your username
  home = {
    username = "quinnieboi";
    homeDirectory = "/home/quinnieboi";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
