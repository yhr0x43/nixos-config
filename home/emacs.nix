{ config, lib, pkgs, ... }:

with lib;

{
  programs.emacs = {
    enable = true;
    extraConfig = builtins.readFile ./init.el;
    extraPackages =
      epkgs: with epkgs; [
        ag
        auctex
        default-text-scale
        magit
        nix-mode
        paredit
        rainbow-delimiters
      ];
  };
}
