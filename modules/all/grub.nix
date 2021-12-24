{ pkgs, lib, config, ... }:
let
  falloutGrubTheme = pkgs.fetchgit {
    url = "https://github.com/shvchk/fallout-grub-theme.git";
    rev = "fe27cbc99e994d50bb4269a9388e3f7d60492ffa";
    sha256 = "1z8zc4k2mh8d56ipql8vfljvdjczrrna5ckgzjsdyrndfkwv8ghw";
  };
in {

  boot.loader.grub.extraConfig = ''
    set theme=($drive1)//themes/fallout-grub-theme/theme.txt
  '';

  boot.loader.grub.splashImage = "${falloutGrubTheme}/background.png";

  system.activationScripts.copyGrubTheme = ''
    mkdir -p /boot/themes
    cp -R ${falloutGrubTheme}/ /boot/themes/fallout-grub-theme
  '';

}
