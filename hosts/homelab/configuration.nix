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
    ../common/locale.nix

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    # inputs.hardware.nixosModules.common-gpu-nvidia
  ];

  # security.sudo.execWheelOnly = true;
  # security.sudo.enable = false;
  # security.lockKernelModules = true;
  # security.auditd.enable = true;

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
    # firewall.enable = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin =  "yes";
      PasswordAuthentication = true;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];
  
  # Bootloader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

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
