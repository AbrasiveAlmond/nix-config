# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../../common/nixos/firefox.nix
    ../../common/nixos/locale.nix
    ../../common/nixos/printing.nix
    ../../common/nixos/ssh.nix
    ../../common/nixos/gnome

    ../../common/nixos/hotspot.nix
    ./immich.nix
    # ./hotspot.nix

    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  system.autoUpgrade.enable = true; # occasionally executes a nixos --switch

  gnome = {
    # Enable the GNOME Desktop Environment.
    enable = true;
  };

  # enable virtualisation hypervisor for gnome boxes in hm
  virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  users.users = {
    quinnieboi = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "i2c"
        "uinput"
        "input"
        "docker"
      ];
    };
  };

  # virtualisation.docker.enable = true;
  # virtualisation.docker.storageDriver = "btrfs";
  # virtualisation.docker.daemon.settings = {
  #   data-root = "/srv/docker";
  #   userland-proxy = false; # designed for Windoze
  # };

  programs.nix-ld.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  # Syncs folder by uploading and downloading to sync
  # But it updates regularly and cannot function on
  # anything but the most recent version, making regular
  # use very hard via a system flake. It also has
  # problems in general; often making -backup file duplicates
  # services.onedrive= {
  #   enable = true;
  #   package = pkgs.unstable.onedrive;
  # };
  # services.syncthing = {
  #   enable = true;
  #   user = "quinnieboi";
  #   dataDir = "/home/quinnieboi/Documents/Synced";
  #   configDir = "/home/quinnieboi/Documents/.config/syncthing";
  # };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    # Enable experimental features to see battery
    # level of connected devices.
    settings.General.Experimental = true;
  };

  fonts.packages = with pkgs.nerd-fonts; [
    _0xproto
    hack
    jetbrains-mono
    iosevka
    fira-code
  ];

  # services.tailscale.enable = true;
  services.ddccontrol.enable = true;
  hardware.i2c.enable = true;

  # Disable until further notice, rebuilding system with 'doas'
  # does not work :/ "error: opening Git repository "/home/quinnieboi/nix-config": repository path '/home/quinnieboi/nix-config' is not owned by current user"
  # security = {
  #   sudo.enable = true;
  #   doas.enable = true;
  #   doas.extraRules = [
  #     # Allow execution of any command by any user in group doas, requiring
  #     # a password and keeping any previously-defined environment variables.
  #     {
  #       groups = [ "doas" ];
  #       noPass = false;
  #       keepEnv = true;
  #     }

  #     # Allow execution of `create_ap` by user `quinnieboi`,
  #     # without a password.
  #     {
  #       # groups = [ "bar" ];
  #       users = [ "quinnieboi" ];
  #       runAs = "root";
  #       noPass = true;
  #       cmd = "/home/quinnieboi/.nix-profile/bin/create_ap";
  #       # args = [ ];
  #     }
  #   ];
  # };

  # accessed via home-manager modules
  # TODO: Configuration requires single file, not directory
  # services.kanata = {
  #   enable = true;
  #   package = pkgs-unstable.kanata;
  #   keyboards = {
  #     main = {
  #       devices = [ "/dev/input/by-id/usb-SINO_WEALTH_RK_Bluetooth_Keyboar-event-kbd" ];
  #       configFile = ../../home/common/kanata-service/colemak/colemak.kbd;
  #     };
  #   };
  # };

  hardware.graphics.enable = true;

  # enable flatpak configuration, apps are installed declaratively in homemanager using module
  services.flatpak.enable = true;

  networking = {
    hostName = "minifridge";
    networkmanager.enable = true;
  };

  # fish completions provided by Nixpkgs along with HM
  # programs.fish.enable = true;

  # Loads ceratin qmk udev rules. Ones missing in ">qmk setup"
  # Makes via work aswell: https://nixos.wiki/wiki/Qmk
  # hardware.keyboard.qmk.enable = true;

  # Open Tablet Driver
  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    nixd
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      optimise.automatic = true;
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = {
        # Makes `nix run nixpkgs#...` run using the nixpkgs from this flake
        nixpkgs.flake = inputs.nixpkgs;

        # https://github.com/clo4/nix-dotfiles/blob/cccef7267a0580e7277ae79377942cbdcd9517a1/systems/host.nix#L42
        my.flake = inputs.self;
      };
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # Revert to old kernel because the latest one may be the cause
  # of my desktop freezing after some minutes running.
  # https://discourse.nixos.org/t/possibly-graphical-problems-with-upgrading-from-24-11-to-25-05/65135/4
  # https://discourse.nixos.org/t/randomly-flickering-freezing-darken-on-amd-gpu/65416

  # Bootloader configuration
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
      "uinput"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];

    kernelParams = [
      "quiet"
      "splash"
      # quiet doesn't work - loglevel was still 4
      # as seen in ./result/boot.json or ./result/kernel-params
      "loglevel=3"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    # Hide OS choice for bootloaders - still accessible via key press
    loader.timeout = 0;

    # Works quite well but does get interrupted a bit
    # other themes: dragon, sphere
    plymouth = {
      enable = true;
      theme = "colorful_sliced";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "colorful_sliced" ];
        })
      ];
    };
  };

  system.stateVersion = "24.05";
}
