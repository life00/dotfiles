{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };
  };

  # ponytail: using tuigreet (simple TUI greeter) — switch to regreet if GUI greeter desired
  # services.greetd.settings.default_session.command =
  #   "${pkgs.greetd.regreet}/bin/regreet; sway";

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
