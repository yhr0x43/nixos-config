{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    initExtra = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    oh-my-zsh = {
      enable = true;
      extraConfig = "
        CASE_SENSITIVE=true
      ";
      plugins = [ "direnv" "pass" ];
      theme = "rgm";
    };
  };

  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    nix-index
    direnv
    nix-direnv-flakes
  ];
}
