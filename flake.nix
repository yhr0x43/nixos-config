{
  description = "yhr_C's very basic flake";

  inputs = {

    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;

    nixos-hardware = {
      url = github:NixOS/nixos-hardware;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = github:nix-community/NUR;

    emacs-overlay.url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;

  };

  outputs = inputs@{self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, nur, emacs-overlay, ...}:
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

      ./cachix.nix

      home-manager.nixosModules.home-manager

      { nixpkgs.overlays = [ overlay-unstable extra-pkgs nur.overlay emacs-overlay.overlay ]; }
      # Let 'nixos-version --json' know about the Git revision of this flake.

      ({ lib, pkgs, nix, ... }: {
        system.stateVersion = "22.05";

        # Enable using the same nixpkgs commit in the imperative tools
        nix.registry = {
          nixpkgs.flake = nixpkgs;
          nixpkgs-unstable.flake = nixpkgs-unstable;
        };

        nix.package = pkgs.nixFlakes;
        nix.autoOptimiseStore = true;

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

    nixosConfigurations.tpx1c = nixpkgs.lib.nixosSystem{
      inherit system;
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1

        ./boxes/tpx1c.nix
        {
          systemd.services.NetworkManager-wait-online.enable = false;
        }
      ] ++ common-modules;
    };

    nixosConfigurations.k26 = nixpkgs.lib.nixosSystem{
      inherit system;
      modules = [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-pc

        ./boxes/k26.nix
      ] ++ common-modules;
    };

    nixosConfigurations.frame = nixpkgs.lib.nixosSystem{
      inherit system;
      modules = [
        nixos-hardware.nixosModules.framework-12th-gen-intel

        ./boxes/frame.nix
      ] ++ common-modules;
    };
  };
}
