{ config, lib, pkgs, ... }:

with lib;
let
  fasm-mode = { lib, trivialBuild, fetchFromGitHub, fetchpatch, emacs }:
    trivialBuild rec {
      pname = "fasm-mode";
      version = "0.1.11";

      src = fetchFromGitHub {
        owner = "emacsattic";
        repo = pname;
        rev = "53286cdc429c0b53d51460ed0bb067455dab5262";
        hash = "sha256-9ve6dYEHjrldOyhcc/BjT+DXL7b6Fkw+mLFqWtE4q0k=";
      };

      meta = with lib; {
        homepage = "https://github.com/emacsattic/fasm-mode";
        inherit (emacs.meta) platforms;
      };
    };
in {
  programs.emacs = {
    enable = true;
    # FIXME magit depends on seq-keep, which is only available after 29.1
    package = pkgs.emacs29-pgtk;
    extraConfig = builtins.readFile ./init.el;
    extraPackages =
      epkgs: with epkgs; [
        ag
        auctex
        default-text-scale
        json-mode
        magit
        melpaPackages.envrc
        nix-mode
        paredit
        rainbow-delimiters

        (callPackage fasm-mode {
            inherit (pkgs) fetchFromGitHub;
        })
      ];
  };
}
