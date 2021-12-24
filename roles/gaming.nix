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
    mumble
  ];

  programs.steam.enable = true;
}
