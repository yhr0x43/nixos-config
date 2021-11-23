{ pkgs, nixpkgs, builtins, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    multimc
    minecraft
    flite              # For Minecraft TTS
    wine
    (lowPrio wineWowPackages.full)
    discord
    steam-run-native
    steam
    mumble
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-runtime-native"
  ];

  programs.steam.enable = true;
}
