{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # outputs.homeManagerModules
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-flatpak.homeManagerModules.nix-flatpaka
    # inputs.nvchad4nix.homeManagerModule

    # ../apps
    # ../../common/home/hotspot.nix
    ../../common/home/kanata-service
    ../../common/home/gnome

    ../../common/home/firefox
    ../../common/home/shellAliases.nix
    ../../common/home/starship.nix
    ../../common/home/tmux.nix
    ../../common/home/git.nix
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.bash.enable = true;

  services.kanata = {
    enable = true;
    user = "quinnieboi";
  };

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages =
    (with pkgs-unstable; [
      lutris
      cartridges

      qemu

      bazaar # Gnome software is a single threaded mess.

      # Gnome apps
      fragments # BitTorrent
      hydrapaper # Gnome utility for multi-screen wallpaper

      # Social
      tuba # Browse the fediverse
      fractal # Matrix Client
      gnome-feeds # RSS Feeds
      spotify

      # Image editing
      darktable # Photo manager and raw developer
      shotwell # Photo manager
      inkscape # Vector graphics editor
      hugin # Panorama stitcher
      ffmpeg # Audio/video cli tools

      # Utilities
      impression # Disk image etcher

      pwvucontrol # Disables monitor audio sleep while running

      discord
      ungoogled-chromium # for limnu

      # coding
      vscodium
      zed-editor
      flatpak-builder # nix packaged one works while flatpackaged one doesn't...

      # Now Handled by rust-devshells flake
      # https://github.com/AbrasiveAlmond/rust-dev-flake
      rust-analyzer
      gnome-builder
      gnome-extensions-cli
      libsecret
      tree
      nil

      vivid
    ])
    ++ (with pkgs; [
      # Due to bug in Zed editor dependency user fonts aren't detected
      open-sans
      x2goclient

      linux-wifi-hotspot
      # errands
      kanata # Keyboard remapping software. I dont think the kanataservice module works without user installation..
      # ddcui # Boot-kernel module "ddcci_backlight" for brightness control
      ddcutil # Brightness

      pika-backup # Backup manager
      nautilus-python # Python bindings for nautilus extension API
      # a dependency for gsconnect that may not be packaged with it.
    ])
    ++ (with pkgs.gnomeExtensions; [
      # Gnome Extensions
      gsconnect
      vertical-workspaces # Nicer workspaces overview
      reboottouefi # Adds uefi boot option
      happy-appy-hotkey # Assign hotkeys to apps to focus or launch them
      dual-shock-4-battery-percentage # power level in top panel
      blur-my-shell # Blurry shell is a needed ux improvement
      caffeine # Keep PC on
      hide-top-bar
      tactile # Tile windows using a custom grid.
      gtile # another tiling thing
      tiling-assistant # Windows-like tiling
      middle-click-to-close-in-overview # Much better.
      control-monitor-brightness-and-volume-with-ddcutil # Control monitor brightness
      burn-my-windows # Visual swag
      tailscale-qs
    ]);

  nix.registry = {
    rust.flake = inputs.rust-devShells;
    python.flake = inputs.python-devShells;
  };

  # These are reset if not manually defined. I would much prefer imperative usage
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
        "monitor-brightness-volume@ailin.nemui"
        "tailscale@joaophi.github.com"
        "gsconnect@andyholmes.github.io"
      ];
    };
  };

  home = {
    username = "quinnieboi";
    homeDirectory = "/home/quinnieboi";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
