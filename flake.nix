{
  description = "yhr_C's very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware, nur, ... }:
    let

      system = "x86_64-linux";

      overlay-unstable = self: super: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.allowBroken = true;
        };
      };

      extra-pkgs = self: super: {
      };

      common-modules = [
        ./modules
        ./cachix.nix

        {
          nixpkgs.overlays =
            [ overlay-unstable extra-pkgs nur.overlays.default ];
        }

        ({ lib, pkgs, nix, ... }: {
          system.stateVersion = "24.11";

          # Enable using the same nixpkgs commit in the imperative tools
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            nixpkgs-unstable.flake = nixpkgs-unstable;
          };

          nix.package = pkgs.nixVersions.stable;
          nix.settings.auto-optimise-store = true;

          nix.extraOptions = "experimental-features = nix-command flakes";
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

      nixosConfigurations.tpx1c = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x1

          ./boxes/tpx1c.nix
          { systemd.services.NetworkManager-wait-online.enable = false; }
        ] ++ common-modules;
      };

      nixosConfigurations.k26 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-pc

          ./boxes/k26.nix
        ] ++ common-modules;
      };

      nixosConfigurations.frame = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.framework-12th-gen-intel
          ./boxes/frame.nix
        ] ++ common-modules;
      };

      nixosConfigurations.mechrev = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = with nixos-hardware.nixosModules; [
          common-pc-laptop-ssd
          common-pc-laptop
          common-cpu-amd

          common-cpu-amd-raphael-igpu
          common-cpu-amd-pstate
          common-gpu-amd
          ./boxes/mechrev.nix
        ] ++ common-modules;
      };
    };
}
