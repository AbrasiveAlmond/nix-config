cat /etc/containers/networks/immich_default.json 
{
     "name": "immich_default",
     "id": "726e7b7ea1c46f634616a37cb78d833cbe8783844b11c0eeff75dac76a94256d",
     "driver": "bridge",
     "network_interface": "podman1",
     "created": "2024-09-24T13:40:59.15700431+12:00",
     "subnets": [
          {
               "subnet": "10.89.0.0/24",
               "gateway": "10.89.0.1"
          }
     ],
     "ipv6_enabled": false,
     "internal": false,
     "dns_enabled": true,
     "ipam_options": {
          "driver": "host-local"
     }
}
