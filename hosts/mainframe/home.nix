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

    ../common/home/kanata-service
    ../common/home/gnome
    ../common/home/firefox
    ../common/home/shellAliases.nix
  ];

  home = {
    username = "busyboy";
    homeDirectory = "/home/busyboy";
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "reboottouefi@ubaygd.com"
        "blur-my-shell@aunetx"
        "happy-appy-hotkey@jqno.nl"
        "caffeine@patapon.info"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "tiling-assistant@leleat-on-github"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "hidetopbar@mathieu.bidon.ca"
      ];
    };
  };

  home.packages = with pkgs; [
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
