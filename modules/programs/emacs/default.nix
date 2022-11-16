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
        config = ./emacs.el;

        defaultInitFile = true;

        package = pkgs.emacsUnstable;

        extraEmacsPackages = epkgs: with epkgs.melpaPackages; [
          evil
          slime
          paredit
          rainbow-delimiters
          ligature
          magit
          nix-mode
          use-package
        ];
      })
    ];
  };
}
