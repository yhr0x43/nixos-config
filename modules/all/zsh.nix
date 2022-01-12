{ pkgs, ... }:

{
	programs.zsh = {
      enable = true;
      histFile = "$HOME/.local/share/zsh/zsh_history";
      ohMyZsh = {
        enable = true;
        theme = "rgm";
      };
      shellInit = ''
        ZDOTDIR=$HOME/.config/zsh
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
	};

    environment.systemPackages = [ pkgs.nix-index ];
}
