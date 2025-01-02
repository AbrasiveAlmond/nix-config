# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, outputs, lib, config, pkgs, pkgs-unstable, ... }: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../common/nixos/ssh.nix
    ../common/nixos/locale.nix
    ../common/nixos/printing.nix

    ../common/nixos/gnome

    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules

    # modules from nixos-hardware repo:
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
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
      extraGroups = [ "wheel" "networkmanager" "i2c" "uinput" "input" ];
      shell = pkgs.nushell; # installed via HM
    };
  };
  # services.tailscale.enable = true;
  services.ddccontrol.enable = true;
  hardware.i2c.enable = true;

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

  # Noticed zero difference with this on
  hardware.graphics.enable = true;

  # enable flatpak configuration, apps are installed declaratively in homemanager using module
  services.flatpak.enable = true;

  networking = {
    hostName = "minifridge";
    # Enable networkinge
    networkmanager.enable = true;
  };

  # fish completions provided by Nixpkgs along with HM
  # programs.fish.enable = true;

  # Loads ceratin qmk udev rules. Ones missing in ">qmk setup"
  # Makes via work aswell: https://nixos.wiki/wiki/Qmk
  hardware.keyboard.qmk.enable = false;

  #### Open Tablet Driver ####
  hardware.opentabletdriver.enable = true;

  # home-manager so the user install stays synced even when changing between channels n stuff
  # user should still be able to easily override the version if they REALLY wanted.
  # hm stays as seperate user controlled app, the system just handles the flake and gives
  # new users an instance so theres no set of funky imperative installation commands to get started.
  environment.systemPackages = with pkgs; [ wget vim git home-manager ];

  nixpkgs = { config = {
    allowUnfree = false;
    # TODO: Find what on earth is using these. Maybe vscode itself?
    permittedInsecurePackages = [
      "dotnet-runtime-6.0.36"
      "dotnet-sdk-wrapped-6.0.428"
      "dotnet-sdk-6.0.428"
    ];
  }; };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
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
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader configuration
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "i2c-dev" "ddcci_backlight" "uinput" ];
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
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
