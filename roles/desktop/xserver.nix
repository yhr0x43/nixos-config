{ pkgs, ...}: {
  services.xserver = {
    enable = true;

    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "yhrc";
      lightdm.enable = true;
    };

    windowManager.bspwm = {
      enable = true;
      configFile = ../../assets/bspwmrc;
      sxhkd.configFile = ../../assets/sxhkdrc;
    };
    displayManager.defaultSession = "none+bspwm";

    # mouse/touchpad
    # --------------
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = true;
        scrollMethod = "twofinger";
        accelSpeed = "2";
      };
    };
  };

  # Xresources config
  # -----------------
  # spread the Xresource config across different files
  # just add a file into `/etc/X11/Xresource.d/` and it will be evaluated.
  #services.xserver.displayManager.sessionCommands = ''
  #  for file in `ls /etc/X11/Xresource.d/`
  #  do
  #    ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresource.d/$file
  #  done
  #'';

  #environment.etc."/X11/Xresource.d/.keep".text = "";

}
