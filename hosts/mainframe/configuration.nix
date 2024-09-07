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
    ../common/firefox.nix

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    # inputs.hardware.nixosModules.common-gpu-nvidia
    # Prime capabilities for hybrid graphics
    # Failed assertions:
    #    - When NVIDIA PRIME is enabled, the GPU bus IDs must be configured.
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
  

  # creates a separate bootable config
  specialisation = { 
    nvidia.configuration = {
      # Nvidia Configuration 
      services.xserver.videoDrivers = lib.mkForce [ "nvidia" ]; 
      # enable discrete GPU in 24.11 or unstable
      hardware.graphics.enable = true;

      hardware.nvidia = {
        # open = true;
        modesetting.enable = true;
        nvidiaSettings = true;

        # # PRIME Arch Wiki
        # # We also need to enable nvidia-persistenced.service to avoid the kernel tearing down the device state whenever the NVIDIA device resources are no longer in use.
        # nvidiaPersistenced = true;
        powerManagement.enable = true; # use with offload according to nixoptions
        powerManagement.finegrained = true;   

        # package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          # If enabled, the NVIDIA GPU will be always on and used for all rendering
          # sync.enable = true; 
          # reverseSync.enable = true;
          offload = { 
            enable = true;
            enableOffloadCmd = true;
          };

          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:44:0:0";
        };
         
      };
      
      
    };

    integrated.configuration = {
      # # Whether to enable configuring X to allow external NVIDIA GPUs when using Prime [Reverse] sync optimus .
      # hardware.nvidia.prime.allowExternalGpu
      
      # # If enabled, the Intel/AMD GPU will be used for all rendering, while enabling output to displays attached only to the NVIDIA GPU without a multiplexer.
      # hardware.nvidia.prime.reverseSync.enable

      # # Whether to enable render offload support using the NVIDIA proprietary driver via PRIME.
      # hardware.nvidia.prime.offload.enable

      nixpkgs.config.packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };

      # Completely disable the NVIDIA graphics card and use the integrated graphics processor instead.
      hardware.nvidiaOptimus.disable = true;
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vpl-gpu-rt
        ];
      };

      # Corruption or unresponsiveness in Chromium and Firefox consult https://wiki.archlinux.org/title/Intel_graphics
      services.xserver.videoDrivers = [ "intel" ];
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
