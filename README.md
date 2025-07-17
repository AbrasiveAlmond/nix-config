# My cluttered NixOS configuration
This contains a hodgepodge of weird ideas and dead code to configure my main linux desktop, laptop, and home server.
Initially based on Misterio77' [Standard starter config](https://github.com/Misterio77/nix-starter-configs)

## Structure
```bash
flake.nix  # Defines the interface for commands and versions
├── common # Reusable bits
└── hosts  # My Machines
    ├── homelab      # WIP Server
    ├── mainframe    # Primary Laptop
    ├── minifridge   # Primary Desktop
    └── stone-tablet # Spare Laptop
```
