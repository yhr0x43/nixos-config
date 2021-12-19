{ pkgs, ...}: {
  services.syncthing = {
    enable = true;
    # use home-manager to launch in user session
    systemService = false;
    user = "yhrc";
    group = "users";
    dataDir = "/home/yhrc";
    configDir = "/home/yhrc/.config/syncthing";

    cert = toString ../secrets/syncthing/cert.pem;
    key = toString ../secrets/syncthing/key.pem;

    folders = {
      dox = {
        enable = true;
        path = "/home/yhrc/dox";
      };
      pass = {
        enable = true;
        path = "/home/yhrc/.local/share/password-store";
      };
    };
  };
}
