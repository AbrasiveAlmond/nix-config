# Structure
* flake.nix # defines overall structure
* /home # configuration for each home manager instance
    + /minifridge
    + /rolling-slab
    + /common/apps
        - /gnome
        - /hyprland
* /hosts # system/hardware configuration
    + /minifridge
    + /macbook
    + /common # reusable bits
        - printing.nix
        - locale.nix
        - /gnome