{ config, lib, pkgs, ... }:

with lib;

let

  #ladspaPath = "${pkgs.ladspaPlugins}/lib/ladspa";

  #jackScript =
  #  pkgs.writeShellScriptBin "jack" (lib.fileContents <assets/jack.sh>);

  #queueElement = {
  #  options = {
  #    plugin = mkOption {
  #      type = with types; str;
  #      description = "file name without suffix of the plugin";
  #    };
  #    label = mkOption {
  #      type = with types; str;
  #      description = "label of the queue element (needs to be correct)";
  #    };
  #    control = mkOption {
  #      type = with types; listOf str;
  #      description = "parameter of plugin";
  #    };
  #  };
  #};

  #sinkElement = {
  #  options = {
  #    name = mkOption {
  #      type = with types; str;
  #      description = "name of the sink";
  #    };
  #    queue = mkOption {
  #      type = with types; listOf (submodule queueElement);
  #      description = "queues";
  #    };
  #  };
  #};

  cfg = config.system.custom.audio;

in {

  options.system.custom.audio = {
    enable = mkEnableOption "use PluseAudio";
    #sinks = mkOption {
    #  type = with types; listOf (submodule sinkElement);
    #  description = "list of sinks";
    #};
  };

  config = mkIf cfg.enable {

    # add virtual midi module
    # -----------------------
    #boot = {
    #  # to route midi signals
    #  # between bitwig and vcvrack
    #  kernelModules = [ "snd_virmidi" ];
    #  # index=-2  prevents from beeing recognised as the default
    #  #           audio device
    #  # midi_devs limit the number of midi devices.
    #  extraModprobeConfig = "options snd-virmidi index=-2 midi_devs=1";
    #};

    # LADSPA
    # ------
    #programs.bash.interactiveShellInit = # sh
    #  ''
    #    # set ladspa library path
    #    # about testing the plugins check analyseplugin command
    #    export LADSPA_PATH=${ladspaPath}
    #  '';
    #programs.zsh.interactiveShellInit = # sh
    #  ''
    #    # set ladspa library path
    #    # about testing the plugins check analyseplugin command
    #    export LADSPA_PATH=${ladspaPath}
    #  '';

    # PulseAudio
    # ----------

    # because of systemWide ensure main user is in audio group
    system.custom.mainUser.extraGroups = [ "audio" ];

    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;

      # all in audio group can do audio
      # systemWide = true;

      extraConfig = ''

        # automatically switch to newly-connected devices
        load-module module-switch-on-connect

      '';
    };

    nixpkgs.config.pulseaudio = true;

    # Packages needed
    # ---------------
    environment.systemPackages = with pkgs; [

      # Music making
      # ------------
      #jackScript
      #jack2Full
      #patchage
      #zynaddsubfx
      #qjackctl

      alsaUtils

      # LADSPA
      # ------
      #ladspaPlugins
      #ladspa-sdk

      # PulseAudio control
      # ------------------
      pavucontrol
      #lxqt.pavucontrol-qt

    ];

  };

}

