{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    # ponytail: minimal-install — `vt` is deprecated (VT now fixed to VT1);
    # the assertion says this option no longer has any effect. Commented, not removed.
    # vt = 1;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };
  };

  # ponytail: using tuigreet (simple TUI greeter) — switch to regreet if GUI greeter desired
  # services.greetd.settings.default_session.command =
  #   "${pkgs.regreet}/bin/regreet; sway";

  systemd.services.greetd = {
    serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "journal";
      StandardError = "journal";
      TTYPath = "/dev/tty1";
      TTYReset = true;
      TTYVHangup = true;
    };
  };
}
