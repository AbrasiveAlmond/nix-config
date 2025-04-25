# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./battery.nix

    ../../common/nixos/ssh.nix
    ../../common/nixos/locale.nix
    ../../common/nixos/printing.nix
    ../../common/nixos/power-management.nix

    ../../common/nixos/gnome
    ../../common/nixos/firefox.nix


    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    # inputs.hardware.nixosModules.common-gpu-nvidia-disable
    # inputs.hardware.nixosModules.common-gpu-nvidia
    # Prime capabilities for hybrid graphics
    # Failed assertions:
    #    - When NVIDIA PRIME is enabled, the GPU bus IDs must be configured.
  ];

  # enable flatpak configuration, apps are installed declaratively in homemanager using module
  services.flatpak.enable = true;

  gnome = {
    # Enable the GNOME Desktop Environment.
    enable = true;
  };

  networking = {
    hostName = "mainframe-laptop";
    # Enable networkinge
    networkmanager.enable = true;
  };

  programs.nix-ld.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures= "client";
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
  };

  #### Open Tablet Driver ####
  hardware.opentabletdriver.enable = true;

  # Touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      tappingDragLock = true;
    };
  };


  # creates a separate bootable config
  specialisation = {
    nvidia.configuration = {
      # Nvidia Configuration
      services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
      # enable discrete GPU in 24.11 or unstable
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vpl-gpu-rt # Still want integrated gpu to do its thing
          intel-media-driver
          intel-ocl
        ];
      };

      hardware.nvidia = {
        open = false; # might want to double check dat
        modesetting.enable = true;
        nvidiaSettings = true;

        # # PRIME Arch Wiki
        # # We also need to enable nvidia-persistenced.service to avoid the kernel tearing down the device state whenever the NVIDIA device resources are no longer in use.
        # https://download.nvidia.com/XFree86/Linux-x86_64/396.51/README/nvidia-persistenced.html
        nvidiaPersistenced = true;
        powerManagement.enable = true; # use with offload according to nixoptions
        powerManagement.finegrained = true;

        # package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          # If enabled, the NVIDIA GPU will be always on and used for all rendering
          # sync.enable = true;
          # reverseSync.enable = true;
          offload = {
            enable = true;
            enableOffloadCmd = true; # Provides `nvidia-offload` command.
          };

          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:44:0:0";
        };

      };

      # ArchWiki 3.2.3 If you use a compositor ... like GNOME, then [below] can usually be disabled to improve performance and decrease power consumption.
      services.xserver.deviceSection = ''
        Option "DRI"             "2"
        Option "TearFree"        "false"
        Option "TripleBuffer"    "false"
        Option "SwapbuffersWait" "false"
      '';
    };

    integrated.configuration = {
      # Stolen from https://github.com/NixOS/nixos-hardware/blob/3f7d0bca003eac1a1a7f4659bbab9c8f8c2a0958/common/gpu/nvidia/disable.nix
      # "disable nvidia, very nice battery life."
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      ## Partially nullified options due to the above
      # Completely disable the NVIDIA graphics card and use the integrated graphics processor instead.
      hardware.nvidiaOptimus.disable = true;

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vpl-gpu-rt
          intel-media-driver
          intel-ocl
        ];
      };

      # Corruption or unresponsiveness in Chromium and Firefox consult https://wiki.archlinux.org/title/Intel_graphics
      # services.xserver.videoDrivers = [ "intel" ]; package removed as it was unmaintained
      # Direct Rendering Infrastructure
      # ArchWiki 3.2.3 If you use a compositor ... like GNOME, then [below] can usually be disabled to improve performance and decrease power consumption.
      services.xserver.deviceSection = ''
        Option "DRI"             "2"
        Option "TearFree"        "false"
        Option "TripleBuffer"    "false"
        Option "SwapbuffersWait" "false"
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    switcheroo-control # D-Bus service to check the availability of dual-GPU
    wget
    vim
    git
  ];

  # Bootloader configuration
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [
      "uinput"
    ];
    extraModulePackages = [config.boot.kernelPackages.ddcci-driver];

    # previously system would hang on shutdown if quiet is enabled
    # https://bbs.archlinux.org/viewtopic.php?id=276631
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

    # Works quite well but does get interrupted a bit
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

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Nvidia drivers error otherwise
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
          "nvidia-persistenced"
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
