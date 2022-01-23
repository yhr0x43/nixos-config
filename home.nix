{ config, pkgs, ... }: {
  imports = [ ];

  programs.home-manager.enable = true;

  home.username = "yhrc";
  home.homeDirectory = "/home/yhrc";

  home.stateVersion = "21.11";

  services.syncthing.enable = true;
  #services.syncthing.tray.enable = true;

  xdg.enable = true;

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "zathura.desktop" ];
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

  programs.password-store = {
    enable = true;
    #FIXME: need to do this since hm sessionVar does not work with nixpkgs managed shell
    # also wrap the program like this for an env variable feels wrong
    package = with pkgs; symlinkJoin {
      name = "pass-with-env";
      paths = [
        (writeShellScriptBin "pass"
        ''
          ${pkgs.coreutils}/bin/env PASSWORD_STORE_DIR=${config.xdg.dataHome}/password-store ${pkgs.pass}/bin/pass "$@"
        '')
      ];
      postBuild = "ln -s ${pkgs.pass}/bin/passmenu $out";
    };
    #settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
  };

  programs.zathura.enable = true;

  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    package = pkgs.gitFull;
    userEmail = "yhr0x43@gmail.com";
    userName = "yhr0x43";
  };

  home.packages = with pkgs; [
    # Browsers
    firefox
    filezilla

    # Editors
    unstable.jetbrains.idea-community

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

  home.sessionVariables = {
    #TODO: more proper home-cleanup
    IPYTHONDIR = "${config.xdg.configHome}/jupyter";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
  };
}
