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

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.10.10.2/24" ];
    listenPort = 51820;
    privateKeyFile = "/persist/etc/nixos/secrets/wireguard-keys/private";
    peers = [
      { publicKey = "82lqun2s77tTgQKVUMxWldyW043pq3jQMt+kDElnPhY=";
        allowedIPs = [ "10.10.10.0/24" ];
        endpoint = "cn.yhrc.xyz:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
