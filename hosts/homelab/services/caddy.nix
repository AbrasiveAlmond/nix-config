({pkgs, ...}: {
  # See immich todo for other ideas for containerised immich
  services.caddy = {
    enable = true;

    # Dont expose immich to the internet. Instead reverse proxy the localhost only.
    virtualHosts."https://192.168.1.7:80".extraConfig = ''
      reverse_proxy http://localhost:2283
    '';

    # Caddy does not support sub-paths 
    # virtualHosts."http://192.168.1.7:80/api".extraConfig = ''
    #   reverse_proxy http://localhost:2283
    # '';
  };

  # services.nginx = {
  #   enable = true;
  #   virtualHosts."http://192.168.1.7:80" = {
  #     locations."/api".proxyPass = "http://localhost:2283/api";
  #   };
  # };

  networking = {
    firewall = {
      allowedTCPPorts = [ 80 ];
    };
  };

  # https://acme-staging-v02.api.letsencrypt.org/directory

  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "qpearson.nz@gmail.com";
  #   certs."mx1.example.org" = {
  #     dnsProvider = "inwx";
  #     # Supplying password files like this will make your credentials world-readable
  #     # in the Nix store. This is for demonstration purpose only, do not use this in production.
  #     environmentFile = "${pkgs.writeText "inwx-creds" ''
  #       INWX_USERNAME=xxxxxxxxxx
  #       INWX_PASSWORD=yyyyyyyyyy
  #     ''}";
  #   };
  # };

})