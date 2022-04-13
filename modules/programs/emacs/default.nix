{ config, emacsWithPackagesFromUsePackage, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.custom.emacs;

in {
  options.programs.custom.emacs = {
    enable = mkEnableOption "enable emacs";
  };

  config = mkIf cfg.enable {
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
