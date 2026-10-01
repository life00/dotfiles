{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  # these fixes are applied to swayfx v0.6
  # FIXME: remove pinned rev once swayfx updates
  # https://github.com/wlrfx/swayfx/issues/569
  # fixed in https://github.com/wlrfx/swayfx/commit/663cf66f92c2d4c99b9c2c4c79ce3538d37470ac
  # FIXME: remove patch once swayfx updates
  # https://github.com/wlrfx/swayfx/issues/565
  nixpkgs.overlays = [
    (final: prev: {
      swayfx-unwrapped = prev.swayfx-unwrapped.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "wlrfx";
          repo = "swayfx";
          rev = "663cf66f92c2d4c99b9c2c4c79ce3538d37470ac";
          hash = "sha256-BYeQAEh47T02mBAModeIL4XNQKftfphN3I9segEb4CM=";
        };
        patches = old.patches ++ [ ../extra/swayfx/565-move-workspace-invisible.patch ];
      });
      # FIXME: remove once opensnitch-ui > 1.8.0
      # prompt crashes when the cursor is outside every screen (wayland), daemon then denies all
      # fixed upstream in ui/opensnitch/dialogs/prompt/dialog.py move_popup()
      opensnitch-ui = prev.opensnitch-ui.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace opensnitch/dialogs/prompt/__init__.py \
            --replace-fail "self.screen().virtualSiblingAt(QtGui.QCursor.pos()).availableGeometry()" \
                           "(self.screen().virtualSiblingAt(QtGui.QCursor.pos()) or self.screen()).availableGeometry()"
        '';
      });
    })
  ];

  # system-scope packages only
  environment.systemPackages = with pkgs; [
    # daemons
    pipewire
    syncthing
    networkmanager
    opensnitch
    usbguard
    ollama
    firewalld

    # admin utils
    btrfs-progs
    e2fsprogs
    cryptsetup
    duperemove
    lsof
    vim
    libargon2
    file
    curl
    git

    # shells
    zsh
    dash

    # WM
    swayfx
    swaylock
    swayidle
    ly
  ];

  # nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.nix-ld.enable = true;
}
