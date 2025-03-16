{
  description = "Template based nixconfig from nix-starter-config";
  # test build with > nixos-rebuild dry-build --flake .#minifridge
  # home-manager switch --flake .#username@hostname
  # when console yells that hm config is different version, try using
  # nix build .#homeConfigurations.me.activationPackage && result/activate
  # running > ./result/bin/home-manager-generation
  # which is a link to the activation package in the current nixos system
  # also worked when followed by home-manager switch as normal
  # !! The actual solution was specifying the release version 24.11 in the url below...

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

    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Another repository to hold development flakes, could be integrated into this one
    rust-devShells = {
      url = "github:AbrasiveAlmond/rust-dev-flake";
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
    rust-devShells,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    # forAllSystems = nixpkgs.lib.genAttrs systems;

    overlay = final: prev: { unstable = nixpkgs-unstable.legacyPackages.${prev.system}; };
    unstableOverlay = ({ config, pkgs, ... }: {
      nixpkgs = {
        overlays = [ overlay ];
        config.allowUnfree = true; # not working for hm - weird temp solution going on
      };
    }
    );
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Main desktop
      minifridge = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

        };

        modules = [
          unstableOverlay
          ./hosts/minifridge/configuration.nix
        ];
      };

      # Dell Inspiron 5502
      mainframe = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };

        modules = [
          unstableOverlay
          ./hosts/mainframe/configuration.nix
        ];
      };

      homelab = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };

        modules = [
          ./hosts/homelab/configuration.nix
        ];
      };

      # 2010/11 MacBook Pro
      stone-tablet = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };

        modules = [
          ./hosts/stone-tablet/configuration.nix
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
          ./hosts/minifridge/home.nix
          unstableOverlay
          nix-flatpak.homeManagerModules.nix-flatpak
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
          unstableOverlay
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
    };
  };
}
