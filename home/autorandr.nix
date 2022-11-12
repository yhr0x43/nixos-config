{ ... }:
{
  programs.autorandr = {
    enable = true;
    profiles = {
      "desktop" = {
        fingerprint = {
          DisplayPort-0 = "00ffffffffffff004dd905c101010101011f0103805f36780a0dc9a05747982712484c2108008180a9c0714fb300010101010101010108e80030f2705a80b0588a00b8173200001e023a801871382d40582c4500b8173200001e000000fc00534f4e5920545620202a33300a000000fd0017790e883c000a20202020202001e5020361f05a7576616065665d5e5f621f101405130420223c3e120311023f402f0d7f071507503d07bc570601670403830f00006e030c004000b8442b0080010203046dd85dc401788063030000000000e200cbe305df01e20f3fe6060d01828220011d007251d01e206e285500b8173200001e00000000000000000000000020";
        };
        config = {
          DisplayPort-0= {
            enable = true;
            primary = true;
            mode = "3840x2160";
            rate = "60";
          };
        };
        hooks.postswitch = "
          bspc monitor DisplayPort-0 -d 1 2 3 4 5 6 7 8 9
        ";
      };
      "tpx1c" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e5db0700000000011c0104a51f1178027d50a657529f27125054000000010101010101010101010101010101013a3880de703828403020360035ae1000001afb2c80de703828403020360035ae1000001a000000fe00424f452043510a202020202020000000fe004e4531343046484d2d4e36310a0043";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            rate = "60";
          };
        };
        hooks.postswitch = "
          bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8 9
        ";
      };
      "frame" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0009e55f0900000000171d0104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a00fb";
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "2256x1504";
            rate = "60";
          };
        };
        hooks.postswitch = "
          bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8 9
        ";
      };
    };
  };
}
