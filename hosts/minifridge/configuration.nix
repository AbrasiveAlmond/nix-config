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
    # ../../common/nixos/locale.nix
    # ../../common/nixos/ssh.nix
    ../../common/nixos/gnome
    ../../common/nixos/gaming.nix

    ./hotspot.nix
    ./immich.nix

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # Enable the GNOME Desktop Environment.
  gnome.enable = true;

  # enable virtualisation hypervisor for gnome boxes in hm
  virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  # Enable CUPS to print documents using the IPP Everywhere protocol
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  users.users = {
    quinnieboi = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "i2c"
        "uinput"
        "input"
      ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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
  hardware = {
    i2c.enable = true;
    uinput.enable = true;
    graphics.enable = true;
    opentabletdriver.enable = true;
  };

  # enable flatpak configuration, apps are installed declaratively in homemanager using module
  services.flatpak.enable = true;

  networking = {
    hostName = "minifridge";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    nixd
  ];

  nixpkgs.config.allowUnfree = true;

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
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      # Makes `nix run nixpkgs#...` run using the nixpkgs from this flake
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      };
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # Bootloader configuration
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # "pkgs-unstable is missing"
    # kernelPackages = pkgs.unstable.linuxPackages_latest;
    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
      # "uinput" # switched to using hardware.uinput.enable
      "kvm-amd"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];

    kernelParams = [
      "quiet"
      "splash"
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

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  system.stateVersion = "24.05";
}
