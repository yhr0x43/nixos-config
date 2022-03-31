{ pkgs, ... }:

{
  programs.command-not-found.enable = false;

  programs.zsh = {
    enable = true;
    histFile = "$HOME/.local/share/zsh/zsh_history";
    ohMyZsh = {
      enable = true;
      plugins = [
        "direnv"
      ];
      theme = "rgm";
    };
    shellInit = ''
      ZDOTDIR=$HOME/.config/zsh
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    vteIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    nix-index

    direnv
    nix-direnv-flakes
  ];
}
