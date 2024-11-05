{
  lib,
  config,
  pkgs,
  inputs,
   ...
}: with lib;
let
  cfg = config.services.kanata;
  kanataFolder = "${../kanata-service}";
in {

  options.services.kanata = {
    enable = mkEnableOption "enable kanata service";
  };

  config = mkIf cfg.enable {
    # Hardened with ProtectHome = true;
    # so this method wouldn't work
    # home.file.".kanata" = {
    #   source = kanataFolder;
    #   recursive = true;
    #   enable = true;
    # };

    systemd.user.services.kanata = {
      Unit.Description = "Kanata Daemon";
      Install.WantedBy = [ "gnome-session-manager.target" ];

      Service = {
        # Make configuration split between multiple files work
        # It’s worth noting that the %h modifier stands for the user’s home directory.
        # https://www.baeldung.com/linux/systemd-create-user-services
        # WorkingDirectory = "%h/.kanata/";
        # ExecStart = (pkgs.kanata) + "/bin/kanata -c ./colemak/colemak.kbd -c ./qwerty/qwerty.kbd";

        # Move config into nix store then harden by disabling access to home directory
        WorkingDirectory = kanataFolder;
        ExecStart = (pkgs.kanata) + "/bin/kanata -c ${kanataFolder}/colemak/colemak.kbd -c ${kanataFolder}/qwerty/qwerty.kbd";

        Type = "exec";
        Restart = "no";

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [
            "/dev/uinput rw"
            "char-input r"
        ];

        # User = "quinnieboi";
        # Group = "kanata"; # Would then require nixos config. I want hm only

        DevicePolicy = "closed";
        IPAddressDeny = [ "any" ];
        KeyringMode = "private";            # Ensures that multiple services running under the same system user ID (in particular the root user) do not share their key material among each other
        LockPersonality = true;            	# Locks personality system call
        MemoryDenyWriteExecute = true;        # Service cannot create writable executable memory mappings
        NoNewPrivileges = true;               # Service may not acquire new privileges
        PrivateNetwork = true;              # no access to the host's network
        PrivateTmp = true;			        # Mount /tmp in own namespace
        PrivateUsers = true;		            # Disable access to other users on system
        ProcSubset = "pid";
        ProtectClock = true;                  # Disable changing system clock
        ProtectControlGroups = true;          # Disable access to cgroups
        ProtectHome = true;
        ProtectHostname = true;               # Service may not change host name
        ProtectKernelLogs = true;		        # Disable access to Kernel Logs
        ProtectKernelModules = true;
        ProtectKernelTunables = true;         # Disable write access to kernel variables
        ProtectProc = "invisible";		    # Disable access to information about other processes
        ProtectSystem = "strict";		        # strict read-only access to the OS file hierarchy
        RestrictAddressFamilies = [ "~AF_PACKET" "~AF_NETLINK" "~AF_UNIX" "~" "~AF_INET" "~AF_INET6"];         # Cannot allocate sockets of any kind
        RestrictNamespaces = true;         	# Disable creating namespaces
        RestrictRealtime = true;              # any attempts to enable realtime scheduling in a process of the unit are refused
        RestrictSUIDSGID = true;              # Disable setting suid or sgid bits
        SystemCallArchitectures = "native";  	# Only allow native system calls
        SystemCallFilter = [                  # “set of system calls used by common services, excluding any special purpose calls”
            "@system-service"
            "~@privileged"
            "~@resources"
        ];
        UMask = 0077;			                # Files created by service are accessible only by service's own user by default
      };
    };
  };
}
