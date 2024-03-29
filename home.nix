{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home/alacritty.nix
    ./home/autorandr.nix
    ./home/emacs.nix
    ./home/dunst.nix
    ./home/polybar.nix
    ./home/rime.nix
    ./home/zsh.nix
  ];

  programs.home-manager.enable = true;

  home.username = "yhrc";
  home.homeDirectory = "/home/yhrc";

  home.stateVersion = "23.05";

  services.syncthing.enable = true;

  xdg.enable = true;

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}/dox";
    download = "${config.home.homeDirectory}/dl";
    music = "${config.home.homeDirectory}/mus";
    pictures = "${config.home.homeDirectory}/pic";
    publicShare = "${config.home.homeDirectory}";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/vid";
  };

  programs.password-store = {
    enable = true;
    # The wrapping happened here so pass can be aware of config.xdg.dataHome
    package = with pkgs; symlinkJoin {
      name = "pass-with-env";
      paths = [ (writeShellScriptBin "pass" ''
          ${pkgs.coreutils}/bin/env PASSWORD_STORE_DIR=${config.xdg.dataHome}/password-store ${pkgs.pass}/bin/pass "$@"
        '') ];
      postBuild = "ln -s ${pkgs.pass}/bin/passmenu $out";
    };
    # NOTE this does not work when shell is not managed by home-manager
    #settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
  };

  programs.zathura.enable = true;

  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    package = pkgs.gitFull;
    userEmail = "yhr0x43@gmail.com";
    userName = "yhr0x43";
    extraConfig = { safe.directory = "/persist/etc/nixos"; };
  };

  home.packages = with pkgs; [
    # Browsers
    firefox
    filezilla

    # Editors
    jetbrains.idea-community

    # Misc. Unix-ish tools
    fzf
    lm_sensors
    ncdu
    nixfmt
    silver-searcher
    zeal

    # Media
    xournalpp
    simple-scan
    texlive.combined.scheme-full
    
    mpv
    feh

    # Office
    libreoffice-fresh

    # python38Packages.xdot

    (aspellWithDicts (d: [ d.en d.en-computers ]))

  ];
}
