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

      # CapabilityBoundingSet = [ "" ];
      # DeviceAllow = [
      #     "/dev/uinput rw"
      #     "char-input r"
      # ];

      # DevicePolicy = "closed";
      # IPAddressDeny = [ "any" ];
      # KeyringMode = "private";              # Ensures that multiple services running under the same system user ID (in particular the root user) do not share their key material among each other
      # LockPersonality = true;            	  # Locks personality system call
      # MemoryDenyWriteExecute = true;        # Service cannot create writable executable memory mappings
      # NoNewPrivileges = true;               # Service may not acquire new privileges
      # PrivateNetwork = true;                # no access to the host's network
      # PrivateTmp = true;			              # Mount /tmp in own namespace
      # PrivateUsers = true;		              # Disable access to other users on system
      # ProcSubset = "pid";
      # ProtectClock = true;                  # Disable changing system clock
      # ProtectControlGroups = true;          # Disable access to cgroups
      # ProtectHome = true;
      # ProtectHostname = true;               # Service may not change host name
      # ProtectKernelLogs = true;		          # Disable access to Kernel Logs
      # ProtectKernelModules = true;
      # ProtectKernelTunables = true;         # Disable write access to kernel variables
      # ProtectProc = "invisible";		        # Disable access to information about other processes
      # ProtectSystem = "strict";		          # strict read-only access to the OS file hierarchy
      # RestrictAddressFamilies = [ "~AF_PACKET" "~AF_NETLINK" "~AF_UNIX" "~" "~AF_INET" "~AF_INET6"];         # Cannot allocate sockets of any kind
      # RestrictNamespaces = true;         	  # Disable creating namespaces
      # RestrictRealtime = true;              # any attempts to enable realtime scheduling in a process of the unit are refused
      # RestrictSUIDSGID = true;              # Disable setting suid or sgid bits
      # SystemCallArchitectures = "native";  	# Only allow native system calls
      # SystemCallFilter = [                  # “set of system calls used by common services, excluding any special purpose calls”
      #     "@system-service"
      #     "~@privileged"
      #     "~@resources"
      # ];
      # UMask = 0077;			                # Files created by service are accessible only by service's own user by default
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
