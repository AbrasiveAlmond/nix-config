{ lib, config, pkgs, ...}: 
let cfg = config.gnome; in {
  options = {
    gnome.enable = lib.mkEnableOption "Enable Module";
  };
  
  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    # on initial boot this uses the correct layout for entering
    # passwords n stuff, since I set kanata to start with the shell/user
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "colemak_dh_ortho";
    };

    # Enable sound with pipewire.
    # sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true; 
    };
  };
}