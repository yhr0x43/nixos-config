{ config, lib, pkgs, ... }:

with lib;

{
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
        melpaPackages.envrc
        magit
        nix-mode
        paredit
        rainbow-delimiters
      ];
  };
}
