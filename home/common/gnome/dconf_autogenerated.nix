# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "" = {
      "plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = false;
        night-light-schedule-from = 18.0;
        night-light-schedule-to = 6.0;
        night-light-temperature = mkUint32 3700;
      };

      "plugins/media-keys" = {
        next = [ "<Super>i" ];
        play = [ "<Super>k" ];
        previous = [ "<Super>l" ];
        screensaver = [];
        volume-down = [ "<Super>e" ];
        volume-up = [ "<Super>u" ];
        www = [ "<Super>space" ];
      };

      "plugins/power" = {
        power-button-action = "interactive";
        sleep-inactive-ac-type = "suspend";
      };

      "plugins/sharing/gnome-user-share-webdav" = {
        enabled-connections = [];
      };
    }
  };
}

  dconf.settings = {
    
  };

  };
}
