{lib, pkgs, config, ... }:
{
  # enable the firewall, Do not open immich port directly.
  networking.firewall.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
#   services.nginx.config = "
# server {
#   listen 80;
#   server_name testing.com 192.168.1.7;
  
#   return 301 localhost:2283;
# }
#   ";
  # services.nginx.enable = true;\
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."localhost" = {
      locations."localhost:2283".proxyPass = "http://localhost:8000";
      listen = [ 
        {
          addr = "127.0.0.1"; 
          port = 80;
        }
      ];
    };

    virtualHosts."localhost.testing" = {
      locations."localhost:2383".proxyPass = "http://localhost:8000";
      listen = [ 
        {
          addr = "127.0.0.1"; 
          port = 80;
        }
      ];
    };
    # appendHttpConfig = "listen 127.0.0.1:80;";  
  };

  # services.nginx = {
  #   enable = true;
  #   recommendedOptimisation = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;
  #   statusPage = true; # http://127.0.0.1/nginx_status

  #   virtualHosts."testing.tld" = {
  #     # addSSL = true;
  #     # kTLS = true;
  #     # forceSSL = true;
  #     # enableACME = true;
  #     locations = {
  #       "/" = {
  #         proxyPass = "localhost:2283";
  #       };
  #     };
  #     # root = "/var/www/myhost.org";
  #     listen = [ 
  #       {
  #         addr = "localhost"; 
  #         port = 443;
  #       }
  #     ];
  #   };
  # };

  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "qpearson.nz@gmail.com";
  # };
}