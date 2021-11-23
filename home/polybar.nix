{ ... }:

{
  services.polybar = {
    enable = true;
    script = "MONITOR=eDP-1 polybar default &";
    config = toString ../assets/polybar;
  };
}
