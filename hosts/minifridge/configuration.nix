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
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules

    # modules from nixos-hardware repo:
      inputs.hardware.nixosModules.common-cpu-amd
      # https://www.reddit.com/r/NixOS/comments/rbzhb1/if_you_have_a_ssd_dont_forget_to_enable_fstrim/
      inputs.hardware.nixosModules.common-ssd

    ../common/locale.nix
    ../common/printing.nix
    # ../common/ssh.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];

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
    kernelModules = ["i2c-dev" "ddcci_backlight"]; 
    extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
    kernelParams = [
      "quiet"
      "splash"
    ];
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

  networking.hostName = "smart-minifridge";
  # Enable networking
  networking.networkmanager.enable = true;

  # Loads ceratin qmk udev rules. Ones missing in ">qmk setup"
  # Makes via work aswell: https://nixos.wiki/wiki/Qmk
  hardware.keyboard.qmk.enable = lib.mkDefault false;

  #### Open Tablet Driver ####
  hardware.opentabletdriver.enable = lib.mkDefault true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

