# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../common/ssh.nix
    ../common/locale.nix
    ../common/printing.nix

    ../common/gnome
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-ssd
  ];

  gnome = {
    # Enable the GNOME Desktop Environment.
    enable = true;
    # Exclude random apps I don't care about
    apps.excludes.enable = true;
  };

  users.users = {
    quinnieboi = {
      isNormalUser = true;
      # openssh.authorizedKeys.keys = [
      #   # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      # ];
      extraGroups = [
        "wheel"
        "networkmanager"
        "i2c"
        "uinput"
        "input"
      ];
    };
  };

  networking = {
    hostName = "smart-minifridge";
    # Enable networkinge
    networkmanager.enable = true;
  };

  # fish completions provided by Nixpkgs along with HM
  programs.fish.enable = true;

  # Loads ceratin qmk udev rules. Ones missing in ">qmk setup"
  # Makes via work aswell: https://nixos.wiki/wiki/Qmk
  hardware.keyboard.qmk.enable = false;

  #### Open Tablet Driver ####
  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];

  nixpkgs = {
    config = {
      allowUnfree = false;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader configuration
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
      "uinput"
      ]; 
    extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
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
    loader.timeout = 1;

    # plymouth = {
    #   enable = true;
    #   theme = "rings";
    #   themePackages = with pkgs; [
    #     # By default we would install all themes
    #     (adi1090x-plymouth-themes.override {
    #       selected_themes = [ "rings" ];
    #     })
    #   ];
    # };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

