{ lib, pkgs, ... }:

{
  profile.workstation.enable = true;
  profile.gaming.enable = true;

  system.custom.fs.enable = true;
  system.custom.fs.bootUuid = "0A5E-C2D1";

  boot = {
    supportedFilesystems = [ "ntfs" ];
    zfs.requestEncryptionCredentials = true;
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    #kernelModules = [ "kvm-amd" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];
      };
    };
  };

  nix.maxJobs = 24;

  services.dnsmasq.enable = true;

  networking.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;

  networking.hostName = "cybermega";
  networking.hostId = "6964344f";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;

  networking.custom.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.10.10.2/24" ];
  };

  services.nginx = {
    enable = true;
    virtualHosts.test = {
      listen = [ { addr = "0.0.0.0"; port = 80; } ];
      locations = {
        "/" = {
          root = "/var/www/html";
          index = "index.html";
          extraConfig = ''ssi on;'';
        };
        #"~ '\\.shtml$'" = {
        #  return = "404";
        #};
      };
    };
  };

  environment.systemPackages = [
    ((pkgs.gradleGen.override {
      java = pkgs.jdk17;
    }).gradle_latest)
  ];
}
