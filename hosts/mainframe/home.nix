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
    ../common/home/gnome

    ../common/home/kanata-service
    ../common/home/firefox
    ../common/home/shellAliases.nix
  ];

  home = {
    username = "busyboy";
    homeDirectory = "/home/busyboy";
  };

  home.packages = (with pkgs; [
      # Gnome apps
      plots         # Worse desmos
      rnote
      speedcrunch
      gnome-secrets # Passwords
      apostrophe    # Markdown Editor
      eyedropper    # Colour picker
      papers        # PDF Reader
      vscodium

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
      git-credential-oauth
      
      # just in case it is more performant
      ungoogled-chromium
  ])++
  (with pkgs.gnomeExtensions; [
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
  ]);

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "happy-appy-hotkey@jqno.nl"
        "caffeine@patapon.info"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "tiling-assistant@leleat-on-github"
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

    # overrides = {
    #   "io.gitlab.librewolf-community".Context = {
    #     filesystems = [
    #       "~/Downloads:rw" # downloads
    #       "~/Documents:ro" # expose documents for uploading
    #     ];        

    #   };
    # };
  };

  # accessed via home-manager modules
  services.kanata.enable = true;

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      #allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["spotify"];
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
