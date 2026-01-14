{
  inputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ../../common/home/gnome
    ../../common/home/git.nix
    ../../common/home/tmux.nix

    ../../common/home/kanata-service
    ../../common/home/firefox
    ../../common/home/shellAliases.nix
  ];

  home = {
    username = "busyboy";
    homeDirectory = "/home/busyboy";
  };

  home.packages = (with pkgs; [
    # goldwarden
    # Gnome apps
    # plots         # Worse desmos
    # rnote
    speedcrunch
    # gnome-secrets # Passwords
    apostrophe    # Markdown Editor
    eyedropper    # Colour picker
    # papers        # PDF Reader
    zed-editor

    gnome-feeds   # RSS Feeds

    # Utilities
    # warp          # File sharing tool

    # Keyboard remapping
    kanata

    tmux
    neovim
    tree
    zoxide

    clang
    # llvmPackages.bintools
    rustup

    # just in case it is more performant
    ungoogled-chromium
  ])++
  (with pkgs.gnomeExtensions; [
    # Gnome Extensions
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
    gsconnect
  ]);


  # dconf.settings."org/gnome/shell" = {
  #     disable-user-extensions = false;
  #     enabled-extensions = with pkgs.gnomeExtensions; [
  #       blur-my-shell.extensionUuid
  #       happy-appy-hotkey.extensionUuid
  #       caffiene.extensionUuid
  #       middle-click-to-close-in-overview.extensionUuid
  #       tiling-assistant.extensionUuid
  #       gsconnect.extensionUuid
  #     ];
  #   };
  # };

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

  nix.registry = {
    rust.flake = inputs.rust-devShells;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
