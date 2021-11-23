{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    prezto = {
      enable = true;
      editor.dotExpansion = true;
      prompt = {
        pwdLength = "long";
        #showReturnVal = true;
        theme = "pure";
      };
      #FIXME: hack around broken showReturnVal in nixpkgs
      #https://github.com/nix-community/home-manager/blob/839645caf35b7004d3422fbdba6db1d762a410d0/modules/programs/zsh/prezto.nix#L446
      extraConfig = "zstyle ':prezto:module:prompt' show-return-val 'yes'";
      utility.safeOps = false;
    };
    shellAliases = {
      # Is "nocorrect rm -I" desired?"
      rm = "rm -I";
    };
  };
  programs.nix-index.enable = true;
}
