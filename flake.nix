{
  description = "NixOS system flake with the Caelestia shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:youwen5/zen-browser-flake";

    skwd-wall = {
      url = "github:liixini/skwd-wall/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia's Hyprland config (hypr/*.lua), linked into ~/.config/hypr.
    caelestia-dots = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };

    # Neovim config (init.lua and lua/), linked into ~/.config/nvim.
    neovim-dots = {
      url = "github:amanullahmenjli/neovim-dots";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    caelestia-shell,
    caelestia-dots,
    neovim-dots,
    qylock,
    skwd-wall,
    zen-browser,
    ...
  }: let
    system = "x86_64-linux";
    caelestia = caelestia-shell.packages.${system};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        skwd-wall.nixosModules.default
        ./modules/animated-wallpapers.nix
        ./hosts/configuration.nix
        ./modules/programming.nix
        ./modules/sddm.nix
        ./modules/bluetooth.nix
        qylock.nixosModules.default
        home-manager.nixosModules.home-manager
      ];
      specialArgs = {
        inherit caelestia caelestia-dots neovim-dots;
        inherit (caelestia-shell) homeManagerModules;
      };
    };
  };
}
