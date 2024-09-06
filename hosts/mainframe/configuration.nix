# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  
    ../common/ssh.nix
    ../common/locale.nix
    ../common/printing.nix
    ../common/power-management.nix

    ../common/gnome

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];
  
  gnome = {
    # Enable the GNOME Desktop Environment.
    enable = true;
    # Gets rid of dedicated cam app among other things.
    # Only limnu uses cam anyways
    apps.excludes.enable = true;
  };

  networking = {
    hostName = "mainframe-laptop";
    # Enable networkinge
    networkmanager.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.busyboy = {
    initialPassword = "changeme";
    isNormalUser = true;
    description = "Quinn Pearson";
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "uinput"
    ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  #### Open Tablet Driver ####
  hardware.opentabletdriver.enable = true;

  # Touchpad
  services.libinput.touchpad = {
   tapping = true;
   tappingDragLock = true;
  };
  
  # enable in 24.11 or unstable
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:44:0:0";
    };

    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #open = true;
    #powerManagement.enable = true;
    #powerManagement.finegrained = true;    
  };
  
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];
  
  # Bootloader.
  # Bootloader configuration
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [
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
  };

  nixpkgs = {
    config = {
      allowUnfree = false;
      # Nvidia drivers error otherwise
      # error: Package ‘nvidia-x11-555.58.02-6.6.47’
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
        ];
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

  system.stateVersion = "24.05";
}
