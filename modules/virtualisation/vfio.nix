{ lib, pkgs, config, ... }:

with lib;

let

  cfg = config.virtualisation.vfio;

in {

  options.virtualisation.vfio = {

    enable = mkEnableOption "VFIO Configuration";

    IOMMUType = mkOption {
      type = types.enum [ "intel" "amd" ];
      example = "intel";
      description = "Type of the IOMMU used";
    };

    devices = mkOption {
      type = types.listOf (types.strMatching "[0-9a-f]{4}:[0-9a-f]{4}");
      default = [ ];
      example = [ "10de:1b80" "10de:10f0" ];
      description = "PCI IDs of devices to bind to vfio-pci";
    };

    disableEFIfb = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Disables the usage of the EFI framebuffer on boot.";
    };

    blacklistNvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Add Nvidia GPU modules to blacklist";
    };

    ignoreMSRs = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description =
        "Enables or disables kvm guest access to model-specific registers";
    };

    applyACSpatch = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If set, the following things will happen:
          - The ACS override patch is applied
          - Applies the i915-vga-arbiter patch
          - Adds pcie_acs_override=downstream to the command line
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    boot.kernelParams = (if cfg.IOMMUType == "intel" then [
      "intel_iommu=on"
      "intel_iommu=igfx_off"
    ] else
      [ "amd_iommu=on" ]) ++ (optional (builtins.length cfg.devices > 0)
        ("vfio-pci.ids=" + builtins.concatStringsSep "," cfg.devices))
      ++ (optional cfg.applyACSpatch
        "pcie_acs_override=downstream,multifunction")
      ++ (optional cfg.disableEFIfb "video=efifb:off")
      ++ (optional cfg.ignoreMSRs "kvm.ignore_msrs=1");

    boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

    boot.initrd.kernelModules =
      [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

    boot.blacklistedKernelModules =
      optionals cfg.blacklistNvidia [ "nvidia" "nouveau" ];

    boot.kernelPatches = optionals cfg.applyACSpatch [
      {
        name = "add-acs-overrides";
        patch = pkgs.fetchurl {
          name = "add-acs-overrides.patch";
          url =
            "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
          sha256 = "b90be7b79652be61f7d50691000f6a8c75a240dc2eee2667b68d984f67583f77";
        };
      }
      #{
      #  name = "i915-vga-arbiter";
      #  patch = pkgs.fetchurl {
      #    name = "i915-vga-arbiter.patch";
      #    url =
      #      "https://aur.archlinux.org/cgit/aur.git/plain/i915-vga-arbiter.patch?h=linux-vfio&id=6f5c5ff2e42abf6606564383d5cb3c56b13d895e";
      #    sha256 = "1mg06dmlsdzf9w6jy73izjpa8ma7yh80k48rjj6iq30qs4jw1d5g";
      #  };
      #}
    ];
  };

}
