{ lib, ... }:

{

  profile.workstation.enable = true;
  profile.gaming.enable = true;

  # FIXME: /etc/tmpfiles.d/00-nixos.conf:17: Duplicate line for path "/etc/NetworkManager/system-connections", ignoring.
  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
  ];

  fileSystems = let disk = fsType: uuid: { inherit fsType; device = "/dev/disk/by-uuid/${uuid}"; };
  in {
    "/"        = disk "ext4" "f2c570f5-5e13-4c71-ae53-32627b7c17da";
    "/boot"    = disk "vfat" "ECC8-A7DD";
    "/nix"     = disk "ext4" "51c2c29b-d73a-4f06-89fb-1ed26ffcfb9b";
    "/persist" = disk "ext4" "9ff01eeb-f39f-4aca-ab09-aac809b10669";
    "/home"    = disk "ext4" "6928d06b-9c7c-4526-8094-7a49f3d209ea";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/4f051bca-6f65-4bf8-903a-183575b6b3ae"; } ];

  boot = {
    initrd.availableKernelModules =
      [ "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.supportedFilesystems = ["zfs"];
    supportedFilesystems = ["zfs"];
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

  networking.networkmanager.enable = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.hostName = "tpx1c";
  networking.hostId = "aa222655";

  services.fprintd.enable = true;

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;

  services.tailscale.enable = true;

  networking.hosts = {
    "127.0.0.1" = [ "analyze.site" ];
  };
  security.pki.certificates = [
  ''
    -----BEGIN CERTIFICATE-----
    MIIEcjCCAtqgAwIBAgIRAMj/BUuhjfvBuD/VgJEgFRowDQYJKoZIhvcNAQELBQAw
    UTEeMBwGA1UEChMVbWtjZXJ0IGRldmVsb3BtZW50IENBMRMwEQYDVQQLDAp5aHJj
    QHRweDFjMRowGAYDVQQDDBFta2NlcnQgeWhyY0B0cHgxYzAeFw0yMjA3MDYxOTUx
    MzhaFw0zMjA3MDYxOTUxMzhaMFExHjAcBgNVBAoTFW1rY2VydCBkZXZlbG9wbWVu
    dCBDQTETMBEGA1UECwwKeWhyY0B0cHgxYzEaMBgGA1UEAwwRbWtjZXJ0IHlocmNA
    dHB4MWMwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQC/4RwQPAaH/kkm
    u5dYQoJ5NCnFR/qNSt3SGsBn7EIiZz73dWL+xYgBgVXo4TSgNrC0jF4BsBEwdIsl
    kJKzUHtNb32U1DA9MGcCDQWMjTuZR/tF94zY0iV17Y7/a28uXzgYGlVptowz3K8q
    UCxDoGAx3zqOi9ZQEAbIWU2e8JAgm/IyvL1ozRihN5J5sMz83Zs/MKKg/tHqxyva
    y5+zfCNFdWjeukeTmvP33cFANEWMVU1zjMitgG7E3d7Z+IlAUOSY8QdporS7cNNx
    L/wPynSAAZABfwW2qGFfEjo9u03JTOT7Z3mjyz1Um6NWWI/VeyPZf/RtdBtH63jm
    L9y0K5C59wnWLBuGxYs6HM7fO1yK6yudvcsEA5XVfiRkS6OxJdU9EuL1TjO+vHPO
    1c/lSF8JsudO15SHzSCpow2oDpAIbLZeCbGvam4qjbMyYoJaj5q7cydRKLfhvn9E
    WRgMBUfO9mfWanqjSlGtFaMv0HqhOIwLFNTyjwwDokULCpVbQMUCAwEAAaNFMEMw
    DgYDVR0PAQH/BAQDAgIEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFNGn
    NCMxyBOIoyYzygmgfVFdxwBbMA0GCSqGSIb3DQEBCwUAA4IBgQBBHeTZ1xS1v5JB
    6lMRYFT+xb32BNMPSEWW5r9wIiK3z4EZvdFvHP7KKuhSUrpSfm+QgHeIkDG9PKqG
    j6Asn2fqomSj5JJnxPntNLOC2YhIVPKn5RKDrFbPiHg19EB4R2cxmM0cGt59ZC1r
    QurDWQWc6Tq7IvVHAGlVS0Lnm6bjpiSGaMisSgpae8nQM7JvLVIl1QXebs0vegGU
    KQS4ZqcIhE5I5EUzMAS6ZpxmIE4InN/YLLg6YBUez8Sw9SjSfZBZlWfLtJQz/nAP
    oGHz2d4VjYSvNVTmGhpm2eCpejMv6KFv9xJuRjCbG9vFfAbTQgEEkKkSbnjFCqMU
    HW38/gkqFD34iWrvFtbFrIUiX2mrbWdtZKW1voW59xDZ5eX7MiOoMVKE7MPm507z
    8FdvwSZZ8NQYt9Sy5SdWICWxY7ITDdLODX9YssUCLb8PN52CRSOMDZ6diHdPkzMH
    8R8X3rm2SfZ6GEx5SwrBR7WNCmcglYXgDL4VUd113wJb0oltpKQ=
    -----END CERTIFICATE-----
  '' ];
}
