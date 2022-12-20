{ pkgs, config, lib, ... }:
with lib;
let

  cfg = config.services.xserver.windowManager;

  stumpwm-wrapper = pkgs.writeShellScriptBin "stumpwm-wrapper" ''
      #! ${pkgs.bash}/bin/bash

      source ${pkgs.lispPackages.stumpwm}/lib/common-lisp-settings/stumpwm-shell-config.sh
      source ${pkgs.lispPackages.clx-truetype}/lib/common-lisp-settings/clx-truetype-shell-config.sh
      source ${pkgs.lispPackages.swank}/lib/common-lisp-settings/swank-shell-config.sh

      "${pkgs.lispPackages.clwrapper}/bin/common-lisp.sh" --quit --eval "(require :stumpwm)" --eval "(stumpwm:stumpwm)"
  '';

in {
  options = {
    services.xserver.windowManager.stumpwm-wrapper.enable = mkEnableOption "stumpwm-wrapper";
  };

  config = mkIf cfg.stumpwm-wrapper.enable {
    services.xserver.windowManager.session = singleton {
      name = "stumpwm-wrapper";
      start = ''
        ${stumpwm-wrapper}/bin/stumpwm-wrapper &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ stumpwm-wrapper ];
  };
}
