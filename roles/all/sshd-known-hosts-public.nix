{ config, pkgs, lib, ... }:

with lib;

{

  services.openssh.knownHosts = {
    github = {
      hostNames = [
        "*.github.com"
        # List generated with
        # curl -sS https://api.github.com/meta | jq -r .git[] | cidr2glob
        "192.30.252.*"
        "192.30.253.*"
        "192.30.254.*"
        "192.30.255.*"
        "185.199.108.*"
        "185.199.109.*"
        "185.199.110.*"
        "185.199.111.*"
        "13.229.188.59"
        "13.250.177.223"
        "18.194.104.89"
        "18.195.85.27"
        "35.159.8.160"
        "52.74.223.119"
      ];
      publicKey =
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
    };
   };

}
