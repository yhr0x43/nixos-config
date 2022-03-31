{ config, emacsWithPackagesFromUsePackage, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.custom.emacs;
  emacsWithPackages = (emacsPackagesFor pkgs.emacsUnstable).emacsWithPackages;
  customEmacs = (emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
                  nix-mode
                  use-package
                ])));

in {
  options.programs.custom.emacs = {
    enable = mkEnableOption "enable emacs";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
        sha256 = "1y0cnhyyv0zdql6r9x61f5jkqxi6v9px6ll04mbl420n7v787f6x";
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

        # Package is optional, defaults to pkgs.emacs
        package = pkgs.emacsUnstable;

        # By default emacsWithPackagesFromUsePackage will only pull in
        # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
        # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
        # and pulls in all use-package references not explicitly disabled via
        # `:ensure nil` or `:disabled`.
        # Note that this is NOT recommended unless you've actually set
        # `use-package-always-ensure` to `t` in your config.
        alwaysEnsure = true;

        # For Org mode babel files, by default only code blocks with `:tangle yes` are considered.
        # Setting `alwaysTangle` to `true` will include all code blocks missing the `:tangle`
        # argument, defaulting it to `yes`.
        # Note that this is NOT recommended unless you have something like
        # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
        # which defaults `:tangle` to `yes`.
        alwaysTangle = true;

        extraEmacsPackages = epkgs: with epkgs.melpaPackages; [
          nix-mode
          use-package
        ];
      })
    ];
  };
}
