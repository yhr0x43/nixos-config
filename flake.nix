{
  description = "yhr_C's very basic flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    emacs-overlay.url =
      "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware
    , home-manager, nur, emacs-overlay, nix-doom-emacs, ... }:
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
        doom-emacs = nix-doom-emacs.packages.${system}.default.override {
          doomPrivateDir = ./doom.d;
        };
      };

      common-modules = [
        ./modules

        ./cachix.nix

        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays =
            [ overlay-unstable extra-pkgs nur.overlay emacs-overlay.overlay ];
        }

        ({ lib, pkgs, nix, ... }: {
          system.stateVersion = "22.11";

          # Enable using the same nixpkgs commit in the imperative tools
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            nixpkgs-unstable.flake = nixpkgs-unstable;
          };

          nix.package = pkgs.nixFlakes;
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
          {
            #FIXME probably should not use nix-doom-emacs like this
            environment.systemPackages = let
              doom-emacs = nix-doom-emacs.packages.${system}.default.override {
                doomPrivateDir = ./doom.d;
              };
            in [ doom-emacs ];
          }

          ./boxes/frame.nix
        ] ++ common-modules;
      };
    };
}
