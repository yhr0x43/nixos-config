# generated by updateSshKeys.sh
{ config, lib, ... }: {

  services.openssh.knownHosts = {
    "[cn2.yhrc.xyz]:63916" = {
      hostNames = [
        "[cn2.yhrc.xyz]:63916"
        "[38.143.2.105]:63916"
      ];
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDc0149yTxhuWKMELgGvsvNUcxmHq6jRsbX3qLk1QFzMXd1S5P9pEKqYv7Gxc5sOt1yjUQ2RBkeH7H+URdDkB7E=";
    };
  };
}
