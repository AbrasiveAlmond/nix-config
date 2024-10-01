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
    ../common/kanata-service
    ../common/gnome
    ../common/keybinds

    ../common/programs/cli
    ../common/programs/firefox
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

      flatpak
      
      # just in case it is more performant
      ungoogled-chromium
  ];

  services.flatpak = {
    enableModule = true;
    packages = [
      "flathub:app/dev.bragefuglseth.Keypunch/x86_64/stable"
      "flathub:app/re.sonny.Workbench/x86_64/stable"
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
