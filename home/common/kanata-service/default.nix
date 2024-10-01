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
    home.file.".kanata" = {
      source = kanataFolder;
      recursive = true;
      enable = true;
    };

    systemd.user.services.kanata = {
      Unit.Description = "Kanata Daemon";
      Install.WantedBy = [ "gnome-session-manager.target" ];

      Service = {
        # Make configuration split between multiple files work
        # It’s worth noting that the %h modifier stands for the user’s home directory. 
        # https://www.baeldung.com/linux/systemd-create-user-services
        # Not a sym-link, and so still requires hm rebuild when you change config
        # perhaps try ExecStartPre="ln -s ${kanataFolder} /store/... "
        # WorkingDirectory = "%h/.kanata/"; 
        # ExecStart = (pkgs.kanata) + "/bin/kanata -c ./colemak/colemak.kbd -c ./qwerty/qwerty.kbd";
        
        
        # Move config into nix store then harden by disabling access to home directory
        WorkingDirectory = kanataFolder; 
        ExecStart = (pkgs.kanata) + "/bin/kanata -c ${kanataFolder}/colemak/colemak.kbd -c ${kanataFolder}/qwerty/qwerty.kbd";

        Type = "exec";
        Restart = "no";

        ## Hardening
        ## System
        ProtectHome = true;
        RestrictNamespaces=true;         		# Disable creating namespaces
        LockPersonality=true;            		# Locks personality system call
        NoNewPrivileges=true;            		# Service may not acquire new privileges
        ProtectKernelModules=true;
        SystemCallArchitectures="native";  	# Only allow native system calls
        ProtectHostname=true;               # Service may not change host name
        RestrictAddressFamilies="";         # Cannot allocate sockets of any kind
        RestrictRealtime=true;              # any attempts to enable realtime scheduling in a process of the unit are refused
        ProtectControlGroups=true;          # Disable access to cgroups
        ProtectKernelTunables=true;         # Disable write access to kernel variables
        RestrictSUIDSGID=true;              # Disable setting suid or sgid bits
        ProtectClock=true;                  # Disable changing system clock
        PrivateNetwork = true;              # no access to the host's network

        ## Capabilities and syscalls
        CapabilityBoundingSet="";
        SystemCallFilter=[
          "@system-service"
          "~@privileged"
        ]; #“set of system calls used by common services, excluding any special purpose calls”

        ## File System
        ProtectSystem="strict";		          # strict read-only access to the OS file hierarchy       
        ProtectProc="invisible";		        # Disable access to information about other processes
        PrivateUsers=true;		              # Disable access to other users on system
        PrivateTmp=true;			              # Mount /tmp in own namespace
        ProtectKernelLogs=true;		          # Disable access to Kernel Logs
        UMask=0077;			                    # Files created by service are accessible only by service's own user by default

        MemoryDenyWriteExecute=true;        # Service cannot create writable executable memory mappings    
      };
    };
  };
}