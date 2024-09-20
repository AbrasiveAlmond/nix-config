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
    ../common/kanata-service
    ../common/gnome

    ../common/programs/cli
    ../common/programs/firefox

    # ../common/programs/cli/fish.nix
    # ../common/programs/cli/starship.nix
  ];

  # improved nix-shell wrapper
  services.lorri.enable = true;
  
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "vertical-workspaces@G-dH.github.com"
        "reboottouefi@ubaygd.com"
        "blur-my-shell@aunetx"
        "happy-appy-hotkey@jqno.nl"
        #"ds4battery@slie.ru"
        "quick-settings-tweaks@qwreey"
        "caffeine@patapon.info"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "tiling-assistant@leleat-on-github"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        # "hidetopbar@mathieu.bidon.ca"
        # "display-brightness-ddcutil@themightydeity.github.com"
      ];
    };
  };

  services.flatpak = {
    enableModule = true;
    packages = [
      "flathub:app/dev.bragefuglseth.Keypunch/x86_64/stable"
      "flathub:app/re.sonny.Workbench/x86_64/stable"
      "flathub:app/io.github.lavenderdotpet.LibreQuake/x86_64/stable"
      "flathub:app/org.gnome.Tau/x86_64/stable"
    ];
    
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    # https://flathub.org/apps/dev.bragefuglseth.Keypunch
  };

  # accessed via home-manager modules
  services.kanata.enable = true;

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = false;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["spotify"];
    };
  };

  systemd.user.sessionVariables = {
		EDITOR = "helix";
		TERM = "fish";
	};

	fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
      # bottles       # Windows app runner
      # plots         # Worse desmos
      # amberol       # Music player
      # mission-center# Task manager 
      # sysprof       # System Profiler

      # Gnome apps
      fragments     # BitTorrent
      gnome-secrets # Passwords
      switcheroo    # Image converter
      hydrapaper    # Gnome utility for multi-screen wlpaper
      eyedropper    # Colour picker
      papers        # PDF reader

      apostrophe    # Markdown editor
      folio         # Note taker
      planify       # Planning software
      qalculate-gtk # Algebraic calculator

      # Social
      fractal       # Matrix Client
      gnome-feeds   # RSS Feeds
      spotify

      # Image editing
      darktable     # Photo manager and raw developer
      shotwell      # Photo manager
      inkscape      # Vector graphics editor
      gimp          # GNU Image Manipulation Program
      hugin         # Panorama stitcher
      ffmpeg        # Audio/video cli tools
      rnote         # Drawing software

      # Utilities
      # Gui
      warp          # File sharing tool
      impression    # Disk image etcher
      pika-backup   # Backup manager

      # No Gui
      pwvucontrol   # Disables monitor audio sleep while running
      ddcui         # Boot-kernel module "ddcci_backlight" for brightness control
      ddcutil       # Brightness

      # coding
      vscodium
      gnome-builder
      gnome-extensions-cli
      libsecret
      git-credential-oauth
      kanata        # Keyboard remapping
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
