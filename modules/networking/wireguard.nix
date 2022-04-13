{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.custom.wireguard;

in {
  options.networking.custom.wireguard = {
    enable = mkEnableOption "custom wireguard configs";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.wireguard.interfaces.wg0 = {
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
  };
}
