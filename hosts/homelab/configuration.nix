# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# See immich todo for tips and useful commands

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ # Include the results of the hardware scan.
    ./locale.nix
    ./hardware-configuration.nix
    ./services/immich.nix

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    # inputs.hardware.nixosModules.common-gpu-nvidia
  ];

  # security.sudo.execWheelOnly = true;
  security.sudo.enable = false;
  security.lockKernelModules = true;
  # security.auditd.enable = true;

  # services.tailscale.enable = true;

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;

    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.7";
        prefixLength = 24;
      }];
    };

    firewall = {
      enable = true;
      pingLimit = "--limit 1/minute --limit-burst 5";
      allowedTCPPorts = [ 22 ];
      # More ports opened by caddy.nix
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = false; # port opened from firewall declaration

    settings = {
      # TODO: Get rid of homelab user all together??
      AllowUsers = [ "homelab" ];
      PermitRootLogin =  "no";
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
#       "b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
# QyNTUxOQAAACBx4sL1n+q7fybEsq//0DvBPui/Pr+asFsRxjtpI2IdpAAAAJhT4q65U+Ku
# uQAAAAtzc2gtZWQyNTUxOQAAACBx4sL1n+q7fybEsq//0DvBPui/Pr+asFsRxjtpI2IdpA
# AAAEBDAjt/UiohegHy7F4ZajaB4ne3ORzxWRWv+k8EYog6KHHiwvWf6rt/JsSyr//QO8E+
# 6L8+v5qwWxHGO2kjYh2kAAAAFXF1aW5uaWVib2lAbWluaWZyaWRnZQ=="

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHiwvWf6rt/JsSyr//QO8E+6L8+v5qwWxHGO2kjYh2k quinnieboi@minifridge"
    ];
    # "SHA256:RIMu6Jf3HaTfTaOsjiTrB8ejunl9GVuPLmyIFFC50NA quinnieboi@minifridge"
  };


  services.fail2ban = {
    enable = true;
    # Ban IP after 2 failures
    maxretry = 2;
    # ignoreIP = [
    #   # Whitelist some subnets
    #   "192.168.0.0/16"
    # ];
    bantime = "1min"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };  

  environment.systemPackages = with pkgs; [
    vim
    # git
    # noip
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
      allowed-users = ["@root"];
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      # flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      # nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    # registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    # nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  system.stateVersion = "24.11";
}