{pkgs, ... } : {
  # environment.packages = [
  #   pkgs.linux-wifi-hotspot # provides create_ap command
  # ];

  systemd.services.hotspot = {
    serviceConfig = {
      # Description = "A service to start a wifi hotspot from the minifridge";
      Type = "simple";
      # Restart = "no";
      # Install.WantedBy = [ "default.target" ];
      # RemainAfterExit = true;
      # Disable wifi, unblock wifi card, then start up hotspot
      ExecStart = "${pkgs.networkmanager}/bin/nmcli r wifi off && ${pkgs.util-linux}/bin/rfkill unblock wlan && sudo ${pkgs.linux-wifi-hotspot}/bin/create_ap --daemon wlp13s0 enp14s0 'Minifridge' 'ColdBeers'";
      # ExecStop = "${pkgs.linux-wifi-hotspot}/bin/create_ap --stop wlp13s0";

    };
  };
}

# With linux-wifi-hotspot
  # $ nix shell nixpkgs#linux-wifi-hotspot
  #
  # Attempt to open a hotspot network
  # $ sudo create_ap wlp13s0 enp14s0 Minifridge
  # ...
  # Creating a virtual WiFi interface... ap0 created.
  # RTNETLINK answers: Operation not possible due to RF-kill
  # ERROR: Maybe your WiFi adapter does not fully support virtual interfaces.
  #
  # The error is misleading, instead run the following and see the wifi adapter is "softblocked"
  # $ rfkill
  # ID TYPE DEVICE    SOFT      HARD
  #  1 wlan phy0   blocked unblocked
  #
  # Then run the following to unblock it, and rerun the hotspot command
  # $ rfkill unblock wlan
  #
  # Now you can make a hotspot :D
  # Try not to use bridge, it seems to disable ethernet.
  # $ sudo create_ap wlp13s0 enp14s0 'Minifridge' 'ColdBeers'
  # I would not reccomend this part below
  # --mkconfig /etc/create_ap.conf -m 'bridge'
  # # on reruns the following should work
  # $ sudo create_ap --config /etc/create_ap.conf
  # oof that broke my ethernet connection, maybe just run w/o config...
