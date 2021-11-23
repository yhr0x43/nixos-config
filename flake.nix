{
  description = "yhr_C's very basic flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, nur }:
  let

    system = "x86_64-linux";

    overlay-unstable = self: super: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    };

    extra-pkgs = self: super: { };

    common-modules = [
      ./modules

      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [ overlay-unstable extra-pkgs nur.overlay ];
        # Let 'nixos-version --json' know about the Git revision of this flake.
      }

      ({ lib, pkgs, nix, ... }: {
        system.stateVersion = "21.05";

        # Enable using the same nixpkgs commit in the imperative tools
        nix.registry = {
          nixpkgs.flake = nixpkgs;
          nixpkgs-unstable.flake = nixpkgs-unstable;
        };

        nix.package = pkgs.nixFlakes;

        nix.extraOptions = "experimental-features = nix-command flakes";
        environment.systemPackages = [ 
          #pkgs.nur.repos.sikmir.librewolf
        ];
        system.configurationRevision = lib.mkIf (self ? rev) self.rev;
      })
    ];

  in {
    nixosConfigurations.cybermega = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-pc

        ./boxes/cybermega.nix
      ] ++ common-modules;
    };

    nixosConfigurations.tpx1c = nixpkgs.lib.nixosSystem{
      inherit system;
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1
        ./boxes/tpx1c.nix
      ] ++ common-modules;
    };
  };
}
