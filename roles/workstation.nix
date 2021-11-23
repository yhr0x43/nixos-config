{ pkgs, hardware, home-manager, ... }: {

  imports = [ ./desktop ];

  services.openssh = {
    enable = true;
    forwardX11 = true;
    passwordAuthentication = false;
  };

  programs.light.enable= true;


  # Needed for steam and many games.
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # For Dualshock 3 support
  hardware.bluetooth.package = pkgs.bluezFull;

  # Networking
  #networking.networkmanager.enable = true;

  environment.variables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    openconnect
    usbutils
    imagemagick
    libnotify
    gimp-with-plugins #GIMP... with plugins?
    #virt-manager
    #spice-gtk

    hackrf
  ];

  services.avahi.enable = true;

  services.deluge = {
    enable = true;
    web.enable = true;
  };

  services.pcscd.enable = true;

  #Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplipWithPlugin
    samsungUnifiedLinuxDriver
    splix
    brlaser
    brgenml1lpr
    brgenml1cupswrapper
    cups-dymo
    mfcl2700dncupswrapper
    mfcl2700dnlpr
  ];

  hardware.sane.enable = true;

  #xdg.portal.enable = true;
  #xdg.portal.gtkUsePortal = true;
  #xdg.portal.extraPortals =
  #  [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];

  services.picom.enable = true;
  services.upower.enable = true;

  services.dbus.enable = true;

  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx";
      fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-rime ];
      fcitx.engines = with pkgs.fcitx-engines; [ mozc rime ];
    };
  };

  #security.wrappers.spice-client-glib-usb-acl-helper.source =
  #  "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  #virtualisation.libvirtd = {
  #  enable = true;
  #  qemuOvmf = true;
  #  qemuRunAsRoot = true;
  #  onBoot = "ignore";
  #  onShutdown = "shutdown";
  #};

  #virtualisation.vfio = {
  #  enable = true;
  #  IOMMUType = "amd";
  #  devices = [ "10de:1b80" "10de:10f0" ];
  #  blacklistNvidia = true;
  #  disableEFIfb = false;
  #  ignoreMSRs = false;
  #  applyACSpatch = true;
  #};

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.mainUser = import ../home.nix;

  nix.trustedUsers = [ "yhrc" ];

  # Way too annoying to manage on a desktop system IMHO
  networking.firewall.enable = false;

}
