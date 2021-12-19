{ config, pkgs, ... }: {
  imports = [ ./home/bspwm.nix ./home/dunst.nix ./home/polybar.nix ./home/zsh.nix ];

  programs.home-manager.enable = true;

  home.username = "yhrc";
  home.homeDirectory = "/home/yhrc";

  home.stateVersion = "21.11";

  services.lorri.enable = true;
  services.syncthing.enable = true;
  services.syncthing.tray.enable = true;

  xdg.enable = true;

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "zathura.desktop" ];
    "x-scheme-handler/steam" = [ "steam.desktop" ];
    "x-scheme-handler/steamvr" = [ "valve-URI-steamvr.desktop" ];
    "x-scheme-handler/vrmonitor" = [ "valve-URI-vrmonitor.desktop" ];
  };

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

  programs.dircolors.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  programs.password-store = {
    enable = true;
    settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store"; 
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font.size = 8;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = true;
  };

  programs.zathura.enable = true;

  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    userEmail = "yhr0x43@gmail.com";
    userName = "yhr0x43";
  };

  home.packages = with pkgs; [
    # Browsers
    firefox
    filezilla

    # Editors
    unstable.jetbrains.idea-community
    (callPackage ./home/neovim.nix {})

    # Misc. Unix-ish tools
    fzf
    sshfs
    pv
    psensor
    ncdu
    zeal

    # Reverse engineering
    #unstable.ghidra-bin
    #jd-gui
    #unstable.python38Packages.binwalk-full

    # Note-taking
    xournalpp
    simple-scan
    texlive.combined.scheme-full

    # Media
    mpv
    feh

    # Office
    libreoffice-fresh

    python38Packages.xdot

    (aspellWithDicts (d: [ d.en ]))
  ];

  xsession.enable = true;
  #xsession.scriptPath = ".hm-xsession";
}
