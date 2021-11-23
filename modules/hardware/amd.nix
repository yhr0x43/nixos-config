{ config, lib, pkgs, ... }:

let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.hardware.custom.gpu.amd;

in {

  options.hardware.custom.gpu.amd = {
    enable = mkEnableOption "AMD GPU";
  };

  config = mkIf cfg.enable {
    # use open source driver
    services.xserver.videoDrivers = [ "amdgpu" ];

    # OpenCL support for BOINC
    services.boinc.extraEnvPackages = with pkgs; [ ocl-icd ];

    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [ rocm-opencl-icd amdvlk ];
    };

    # For amdvlk
    environment.variables.VK_ICD_FILENAMES =
      "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  };

}
