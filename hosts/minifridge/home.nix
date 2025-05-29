{
  inputs,
  # outputs,
  lib,
  # config,
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
    inputs.nvchad4nix.homeManagerModule

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

  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    packages = [ # All installing from flathub stable by default
      "dev.bragefuglseth.Keypunch"
      "re.sonny.Workbench"
      # "io.gitlab.librewolf-community" # deal with switching later if I care
      # "org.mozilla.firefox"
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
  };

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # allowUnfreePredicate =
      #   pkg:
      #   builtins.elem (lib.getName pkg) [
      #     "spotify"
      #     "discord"
      #     "morgen"
      #     "obsidian"
      #   ];
      allowUnfreePredicate = (_: true);
    };

    overlays = [
      (final: prev: {
        nvchad = inputs.nvchad4nix.packages."${pkgs.system}".nvchad;
      })
    ];
  };

  # Config is entirely imperative :\
  # services.syncthing = {
  #   enable = true;
  # };

  services.kanata.enable = true;
  fonts.fontconfig.enable = true;

  # https://github.com/nix-community/nix4nvchad?tab=readme-ov-file#available-options
  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = false;
    # Loaded by lazy.nvim
    extraPlugins = ''
return {
  {
    "nvim-lspconfig/nvim-lspconfig",
    opts = { servers = { rust_analyzer = { enabled = true }, }, },
  }
};
    '';
    extraPackages = with pkgs; [
      emmet-language-server
      nixd
      (python3.withPackages(ps: with ps; [
        python-lsp-server
        flake8
      ]))
    ];
  };

  # switch to diff syntax like below
  # home.packages = with pkgs; {
  #  ...
  #  unstable = {
  #    ...
  #  }
  #  gnomeExtensions = {
  #    ...
  #  }
  # }

  home.packages = with pkgs;
    (with pkgs-unstable; [ # cannot use pkgs.unstable due to strange unfree attribute not setting
    gnomeExtensions.gsconnect
    onedrivegui

    obsidian
    morgen
    bitwarden-desktop
    valent

    # goldwarden # Couldn't get api keys to work :/
    # bottles         # Run windows apps # Removed due to build errs + I don't use
    # plots         # Worse desmos
    # amberol         # Music player
    # shortwave       # Internet radio player
    # mission-center  # Task manager
    # sysprof       # System Profiler

    # Gnome apps
    fragments       # BitTorrent
    # varia           # Download manager with torrent support and browser integration
    # gnome-secrets   # Passwords
    hydrapaper      # Gnome utility for multi-screen wlpaper


    qalculate-gtk   # Algebraic calculator

    # Social
    tuba # Browse the fediverse
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
    # rnote # Drawing software
    identity # Compare photos and videos

    # Utilities
    # warp # File sharing tool
    impression # Disk image etcher
    # video-trimmer

    pwvucontrol # Disables monitor audio sleep while running

    discord
    ungoogled-chromium # for limnu
    # tangram # Run web apps on desktop

    # coding
    vscodium
    zed-editor
    flatpak-builder # nix packaged one works while flatpackaged one doesn't...

    # Now Handled by rust-devshells flake
    # https://github.com/AbrasiveAlmond/rust-dev-flake
    # cargo
    # gcc
    # rustc
    rust-analyzer
    # rustup # collides with cargo
    gnome-builder
    gnome-extensions-cli
    libsecret
    tree
    # zoxide
    # nixd
    nil

    vivid
    ])
    ++
    (with pkgs; [
    # Due to bug in Zed editor dependency user fonts aren't detected
    linux-wifi-hotspot
    # errands
    kanata # Keyboard remapping software. I dont think the kanataservice module works without user installation..
    # ddcui # Boot-kernel module "ddcci_backlight" for brightness control
    ddcutil # Brightness

    pika-backup # Backup manager
    ])
    # ++
    # (with inputs; [
    # zen-browser.packages.x86_64-linux.default
    # ])
    ++
    (with pkgs.gnomeExtensions; [
    # valent                          # Gnome Desktop integration for Valent (KDEConnect Protocol)
    # Gnome Extensions
    vertical-workspaces             # Nicer workspaces overview
    reboottouefi                    # Adds uefi boot option
    happy-appy-hotkey               # Assign hotkeys to apps to focus or launch them
    dual-shock-4-battery-percentage # power level in top panel
    blur-my-shell                   # Blurry shell is a needed ux improvement
    caffeine                        # Keep PC on
    hide-top-bar
    tactile                         # Tile windows using a custom grid.
    gtile                           # another tiling thing
    tiling-assistant                # Windows-like tiling
    middle-click-to-close-in-overview # Much better.
    control-monitor-brightness-and-volume-with-ddcutil # Control monitor brightness
    burn-my-windows                 # Visual swag
    tailscale-qs
  ]);

  nix.registry = {
    rust.flake = inputs.rust-devShells;
  };

  # Why must they be reset if not manually defined. I would much prefer imperative usage
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
      ];
    };
  };

  home = {
    username = "quinnieboi";
    homeDirectory = "/home/quinnieboi";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  # programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
