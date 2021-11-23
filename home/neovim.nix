{ pkgs, neovim, vimPlugins, vimUtils, fetchFromGitHub, lib, ... }:

let

  customRC = builtins.readFile ../assets/init.vim;

  vim-scarpet = pkgs.vimUtils.buildVimPlugin {
    name = "vim-scarpet";
    src = fetchFromGitHub {
      owner = "twh2898";
      repo = "vim-scarpet";
      rev = "8094b6796e5cd002c14f8d189aaf1abccb70e2e4";
      sha256 = "K/hLId4bD5oQiM9x5gUi7QM/kSRPBF7HfzHyk+Q74CU=";
    };
  };

in

neovim.override {
  vimAlias = true;
  configure = {
    inherit customRC;

    vam.knownPlugins = pkgs.vimPlugins // { inherit vim-scarpet; };
    vam.pluginDictionaries = [
      { names = [
        "deoplete-nvim"
        "vim-nix"
        "vimtex"
        "vim-scarpet"
        "LanguageClient-neovim"
      ]; }

      { names = [
        "rust-vim"
        "deoplete-rust"
      ]; ft_regex = "^rust\$"; }

      { names = [
        "markdown-preview-nvim"
      ]; ft_regex = "^markdown\$"; }

      #{ name = "vim-nix"; ft_regex = "^nix\$"; }
    ];
  };

} 

#(vim_configurable.customize {
#  name = "vim-with-plugins";
#  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
#    start = [ vimtex ];
#    # manually loadable by calling `:packadd $plugin-name`
#    opt = [ ];
#    # autocmd FileType php :packadd phpCompletion
#  };
#})
