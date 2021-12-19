{ ... }:
{
  programs.autorandr =
  let
    fingerprint = {
      DisplayPort-0 = "00ffffffffffff005c23701000000000071e0103801d11782ab865a2565698240a5054a10800d1c0a940818001010101010101010101023a801871382d40582c450026a61000001e000000fd00384c1e5011000a202020202020000000fc005761636f6d204f6e652031330a000000ff0030425730313731303033323735018e020311804310020465030c001000e2006a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041";
      DisplayPort-1 = "00ffffffffffff004a8b4038010101012a1c0103800000783eee91a3544c99260f5054bfef80d1c0d1e8d1fc950090408180814081c040d000a0f0703e803020350058c31000001a000000fc00582045515549500a2020202020000000ff0064656d6f7365742d310a203020000000fd0018900fde3c000a20202020202001b9020356f25e04051013141f2021222748494a4b4c5d5e5f606162636465666768696a6be200d5e305c00023097f0783010000e50f00000c006e030c00100038782000800102030467d85dc401788801e606050169694f023a801871382d40582c250058c31000001e011d8018711c1620582c250058c31000009e000000000066";
      HDMI-A-0 = "00ffffffffffff0020a33000010000000c1d0103807341780acf74a3574cb02309484c21080081c0814081800101010101010101010108e80030f2705a80b0588a00ba882100001e023a801871382d40582c4500501d7400001e000000fc00484953454e53450a2020202020000000fd00184b0f883c000a202020202020012c020377705a615e5f605d6a6b01020405101113141f20212212036566626364320907071507505706013d07c06704035f7e0183010000e200f9e305ff016e030c001000383c2000800102030468d85dc40178800702e61146d0007080e3060d01eb0146d000441f329e3e26aae5018b849001e40f6900600000000000000000fa";
      eDP-1 = "00ffffffffffff0009e5db0700000000011c0104a51f1178027d50a657529f27125054000000010101010101010101010101010101013a3880de703828403020360035ae1000001afb2c80de703828403020360035ae1000001a000000fe00424f452043510a202020202020000000fe004e4531343046484d2d4e36310a0043";
    };
  in {
    enable = true;
    profiles = {
      "desktop-3" = {
        inherit fingerprint;
        config = {
          HDMI-A-0 = {
            enable = true;
            primary = true;
            position = "1080x0";
            mode = "3440x1440";
            rate = "100";
          };
          DisplayPort-1= {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
            rotate = "left";
          };
          DisplayPort-0 = {
            enable = true;
            position = "1080x1440";
            mode = "1920x1080";
            rate = "60";
          };
        };
        hooks.postswitch = "
          bspc config -m DisplayPort-0 top_padding 0
          bspc config -m DisplayPort-1 top_padding 0
          xsetwacom --set \"Wacom One Pen Display 13 Pen stylus\" MapToOutput HDMI-A-0
        ";
      };
      "desktop" = {
        inherit fingerprint;
        config = {
          HDMI-A-0 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "60";
          };
          DisplayPort-0= {
            enable = true;
            position = "1920x2160";
            mode = "1920x1080";
            rate = "60";
          };
        };
        hooks.postswitch = "
          bspc monitor HDMI-A-0 -d 1 2 3 4 5 6 7 8 9
          bspc config -m DisplayPort-0 top_padding 0
          xsetwacom --set \"Wacom One Pen Display 13 Pen stylus\" MapToOutput DisplayPort-0
        ";
      };
      "tpx1c" = {
        inherit fingerprint;
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
    };
  };
}
