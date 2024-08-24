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
    # outputs.homeManagerModules
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    # ../apps
    ../kanata-service/default.nix
    ../gnome
    # ../programs/nvim
    ../programs/cli
    ../programs/firefox
  ];

  # accessed via home-manager modules
  services.kanata.enable = true;

  nixpkgs = {
    # You can add overlays here
    # overlays = [
    #   # Add overlays your own flake exports (from overlays and pkgs dir):
    #   outputs.overlays.additions
    #   outputs.overlays.modifications
    #   outputs.overlays.unstable-packages

    #   # You can also add overlays exported from other flakes:
    #   # neovim-nightly-overlay.overlays.default
    # ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = false;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["spotify"];
    };
  };

  home.packages = with pkgs; [
       # Gnome apps
      # plots       # Worse desmos
      fragments     # BitTorrent
      gnome-secrets # Passwords
      amberol       # Music player
      apostrophe    # Markdown Editor
      switcheroo    # Image converter
      hydrapaper    # Gnome utility for multi-screen wlpaper
      eyedropper    # Colour picker
      devhelp # Local Docs browser
      vscodium
      citations
      planify
      mission-center
      flameshot
      drawing

      # Social
      fractal       # Matrix Client
      gnome-feeds   # RSS Feeds

      # Image editing
      # xournalpp
      darktable
      krita
      inkscape
      gimp
      hugin
      ffmpeg
      identity
      shotwell
      rnote

      # Utilities
      warp          # File sharing tool
      pika-backup   # Backup manager
      ddcui         # boot-kernel module "ddcci_backlight" for brightness control
      ddcutil       # brightness

      # When it is running it disables power_saving / auto_suspend / whatever makes audio take 5s to cut in
      pwvucontrol # Better looking - same functionality

      # Keyboard remapping
      kanata

      gnome-builder
      gnome-extensions-cli
      
      # firefox
      spotify
  ];

  programs.starship = {
    enable = lib.mkDefault true;
    # enableZshIntegration = true;
  };

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
