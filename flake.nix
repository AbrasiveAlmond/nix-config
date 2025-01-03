{
  description = "Template based nixconfig from nix-starter-config";
  # test build with > nixos-rebuild dry-build --flake .#minifridge
  # home-manager switch --flake .#username@hostname
  # when console yells that hm config is different version, try using
  # nix build .#homeConfigurations.me.activationPackage && result/activate
  # running > ./result/bin/home-manager-generation 
  # which is a link to the activation package in the current nixos system
  # also worked when followed by home-manager switch as normal

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # May be useful for server - interesting repo nonetheless
    # nix-mineral = {
    #   url = "github:cynicsketch/nix-mineral"; # Refers to the main branch and is updated to the latest commit when you use "nix flake update" 
    #   flake = false;
    # };

    hardware.url = "github:nixos/nixos-hardware";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";

    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    systems,
    nix-flatpak,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Supported systems for your flake packages, shell, etc.
    # systems = [
    #   # "aarch64-linux"
    #   # "i686-linux"
    #   "x86_64-linux"
    #   # "aarch64-darwin"
    #   # "x86_64-darwin"
    # ];
    system = "x86_64-linux";
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system})
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Ending import at a directory defaults to <dir>/default.nix
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    
    # immich = import ./pkgs
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    # homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Main desktop
      minifridge = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          # inherit overlays;
        };

        modules = [
          # > Our main nixos configuration file <
          ./hosts/minifridge/configuration.nix
          # home-manager.nixosModules.home-manager
        ];

      };

      # 2010/11 MacBook Pro
      stone-tablet = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };

        modules = [
          # > Our main nixos configuration file <
          ./hosts/stone-tablet/configuration.nix
        ];
      };

      # Dell Inspiron 5502
      mainframe = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };

        modules = [
          # > Our main nixos configuration file <
          ./hosts/mainframe/configuration.nix
        ];
      };

      homelab = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        
        modules = [
          # > Our main nixos configuration file <
          ./hosts/homelab/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Personal Desktop
      "quinnieboi@minifridge" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs nix-flatpak;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          # > Our main home-manager configuration file <
          ./hosts/minifridge/home.nix
          nix-flatpak.homeManagerModules.nix-flatpak
        ];
      };

      # 2010/11 MacBook Pro
      "quinnieboi@stone-tablet" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/stone-tablet/home.nix
        ];
      };

      # Dell Inspiron 5502
      "busyboy@mainframe" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/mainframe/home.nix
          nix-flatpak.homeManagerModules.nix-flatpak
        ];
      };
    };
  };
}
