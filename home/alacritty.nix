{ config, pkgs, ... }:

let

  settings = {
    env.TERM = "xterm-256color";
  };

in {
  # https://github.com/nix-community/home-manager/blob/afe96e7433c513bf82375d41473c57d1f66b4e68/modules/programs/alacritty.nix#L52
  xdg.configFile."alacritty/alacritty.yml" = mkIf (settings != { }) {
    text = replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON settings);
  };
}
