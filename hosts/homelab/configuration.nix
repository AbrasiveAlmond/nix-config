# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# See immich todo for tips and useful commands

{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [ # Include the results of the hardware scan.
    ./locale.nix
    ./hardware-configuration.nix
    # ./services/immich.nix

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    # inputs.hardware.nixosModules.common-gpu-nvidia
  ];

  # This file only defines the base system,
  # by removing extra imports it should be a functional & bare system.

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;

    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.7";
        prefixLength = 24;
      }];
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;

    settings = {
      # TODO: Get rid of homelab user all together??
      AllowUsers = [ "homelab" ];
      PermitRootLogin =  "no"; # can get root via homelab "bash> su"
      PasswordAuthentication = false;
    };
  };

  users.users.homelab = {
    initialPassword = "changeme";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHiwvWf6rt/JsSyr//QO8E+6L8+v5qwWxHGO2kjYh2k quinnieboi@minifridge"
    ];
  };

# No fail2ban cause no passwords allowed
  # services.fail2ban = {
  #   enable = true;
  #   # Ban IP after 2 failures
  #   maxretry = 2;
  #   bantime = "1min"; # Ban IPs for one day on the first ban
  #   bantime-increment = {
  #     enable = true; # Enable increment of bantime after each violation
  #     multipliers = "1 2 4 8 16 32 64";
  #     overalljails = true; # Calculate the bantime based on all the violations
  #   };
  # };

  environment.systemPackages = with pkgs; [
    vim
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
    # TODO: Only allowed user is root
      # allowed-users = ["@root"];
      experimental-features = "nix-command flakes";
    };
    # Opinionated: disable channels
    channel.enable = false;
  };

  system.stateVersion = "24.11";
}
