{ pkgs, ... }:

let

  vim-scarpet = pkgs.vimUtils.buildVimPlugin {
    name = "vim-scarpet";
    src = pkgs.fetchFromGitHub {
      owner = "twh2898";
      repo = "vim-scarpet";
      rev = "8094b6796e5cd002c14f8d189aaf1abccb70e2e4";
      sha256 = "K/hLId4bD5oQiM9x5gUi7QM/kSRPBF7HfzHyk+Q74CU=";
    };
  };

in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    runtime = {
      #FIXME: why etc needed here? seems to be implementation (or documentation) error in nixpkgs
      "etc/ftplugin/sml.vim".text = ''nnoremap <buffer> <F9> :!sml "%:p"<CR>'';
    };
    configure = {
      customRC = builtins.readFile ../../assets/init.vim;

      #TODO: many plugins and the plugin manager here need update
      vam.knownPlugins = pkgs.vimPlugins // { inherit vim-scarpet; };
      vam.pluginDictionaries = [
        { names = [
          "deoplete-nvim"
          "vim-nix"
          "vimtex"
          "vim-scarpet"
          "nerdcommenter"
          "LanguageClient-neovim"
        ]; }

        { names = [
          "rust-vim"
          #"deoplete-rust"
        ]; ft_regex = "^rust\$"; }

        { names = [
          "markdown-preview-nvim"
        ]; ft_regex = "^markdown\$"; }

        { names = [
          "deoplete-lsp"
        ]; ft_regex = "^c\$"; }

        { names = [
          "haskell-vim"
        ]; ft_regex = "^l\\?hs\$"; }

        #{ name = "vim-nix"; ft_regex = "^nix\$"; }
      ];
    };
  };
}
