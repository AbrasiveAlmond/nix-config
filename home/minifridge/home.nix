{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # outputs.homeManagerModules
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    # inputs.nix-flatpak.homeManagerModules.nix-flatpak
    # ../apps
    ../common/kanata-service
    ../common/gnome
    ../common/keybinds

    ../common/programs/cli
    ../common/programs/firefox
    ../common/shellAliases.nix

    # ../common/programs/cli/fish.nix
    # ../common/programs/cli/starship.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "vertical-workspaces@G-dH.github.com"
        "reboottouefi@ubaygd.com"
        "blur-my-shell@aunetx"
        "happy-appy-hotkey@jqno.nl"
        "quick-settings-tweaks@qwreey"
        "caffeine@patapon.info"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "tiling-assistant@leleat-on-github"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
      ];
    };
  };

  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    packages = [ # All installing from flathub stable by default
      "dev.bragefuglseth.Keypunch"
      "re.sonny.Workbench"
      "io.github.lavenderdotpet.LibreQuake"
      "io.gitlab.librewolf-community"
      # can't figure it out declaratively so harden librewolf via this
      # okay imma run the nofilesystem command from below since flatseal is giving ro access to /?
      # https://discourse.nixos.org/t/my-experience-and-reasons-using-flatpak-on-nixos/30880
      "com.github.tchx84.Flatseal" 
    ];

    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    overrides = {
      "io.gitlab.librewolf-community".Context = {
        filesystems = [
          "~/Downloads:rw" # downloads
          "~/Documents:ro" # expose documents for uploading
        ];        

      };
    };
  };

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "spotify"
          "discord"
        ];
    };
  };

  services.kanata.enable = true;

  # systemd.user.sessionVariables = {
  # 	EDITOR = "helix";
  # 	TERM = "fish";
  # };
  #home.file.".vimrc".text = "inoremap st";
  fonts.fontconfig.enable = true;
  home.packages = 
   (with pkgs; [
    (nerdfonts.override {
      fonts = [
        "Hack"
        "0xProto"
      ];
    })
    inputs.nixvim.packages.x86_64-linux.default
    # bottles       # Windows app runner
    # plots         # Worse desmos
    # amberol       # Music player
    mission-center # Task manager
    # sysprof       # System Profiler

    # Gnome apps
    fragments # BitTorrent
    gnome-secrets # Passwords
    switcheroo # Image converter
    hydrapaper # Gnome utility for multi-screen wlpaper
    eyedropper # Colour picker
    papers # PDF reader

    apostrophe # Markdown editor
    folio # Note taker
    planify # Planning software
    qalculate-gtk # Algebraic calculator

    # Social
    fractal # Matrix Client
    gnome-feeds # RSS Feeds
    spotify

    # Image editing
    darktable # Photo manager and raw developer
    shotwell # Photo manager
    inkscape # Vector graphics editor
    gimp # GNU Image Manipulation Program
    hugin # Panorama stitcher
    ffmpeg # Audio/video cli tools
    rnote # Drawing software

    # Utilities
    # Gui
    warp # File sharing tool
    impression # Disk image etcher
    pika-backup # Backup manager

    # No Gui
    pwvucontrol # Disables monitor audio sleep while running
    ddcui # Boot-kernel module "ddcci_backlight" for brightness control
    ddcutil # Brightness

    discord
    ungoogled-chromium # for limnu

    # coding
    vscodium
    # gnome-builder
    # gnome-extensions-cli
    libsecret
    git-credential-oauth
   ]);
  #  ++
  #  (with pkgs-unstable; [
  #   kanata
  #  ]);

  home = {
    username = "quinnieboi";
    homeDirectory = "/home/quinnieboi";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
