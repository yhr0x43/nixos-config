{ config, emacsWithPackagesFromUsePackage, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.custom.emacs;

in {
  options.programs.custom.emacs = {
    enable = mkEnableOption "enable emacs";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
        sha256 = "1v7rg1s9qwpwhmd37ainwk6klhf4x7ifjg9h5amgss744gg4hin4";
      }))
    ];

    environment.systemPackages = [
      (pkgs.emacsWithPackagesFromUsePackage {
        # Your Emacs config file. Org mode babel files are also
        # supported.
        # NB: Config files cannot contain unicode characters, since
        #     they're being parsed in nix, which lacks unicode
        #     support.
        # config = ./emacs.org;
        config = ./init.el;

        package = pkgs.emacsUnstable;

        extraEmacsPackages = epkgs: with epkgs.melpaPackages; [
          evil
          magit
          nix-mode
          use-package
        ];
      })
    ];
  };
}
