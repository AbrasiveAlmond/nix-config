{ lib, config, ... }:
let
  cfg = config.gnome;
in
{
  options = {
    gnome.enable = lib.mkEnableOption "Enable Module";
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    # services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Whether to enable Sushi, a quick preview for nautilus.
    services.gnome.sushi.enable = true;

    # Enable sound with pipewire.
    # sound.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/mutter" = {
            experimental-features = [
              "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
              "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
              "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
              "autoclose-xwayland" # automatically terminates Xwayland if all relevant X11 clients are gone
            ];
          };
        };
      }
    ];
  };
}
