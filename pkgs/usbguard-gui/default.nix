{
  lib,
  python3Packages,
  fetchFromGitHub,
  perl,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "usbguard-gui";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "gunchev";
    repo = "usbguard_gui";
    rev = "42bfdd4bbec995bbfb2b21e02458996bcf8f9e61";
    hash = "sha256-EJgND09SzvX/hhzyNGOeUCVq1USkXe8/1mi+0hpgofg=";
  };

  pyproject = true;

  dependencies = with python3Packages; [
    pyqt6
    dbus-fast
  ];

  nativeBuildInputs = with python3Packages; [
    hatchling
    perl
  ];

  makeWrapperArgs = [ "--prefix QT_PLUGIN_PATH : ${qt6.qtsvg}/lib/qt-6/plugins" ];

  # relax the ScreenSaver lock-availability gate for Sway, which has no
  # org.freedesktop.ScreenSaver D-Bus service. Kept in package so upstream bumps
  # just drop a new rev here. Device actions stop requiring screen-lock; the HID
  # lock-first BadUSB flow stays off (lock_available stays false)
  postPatch = ''
    perl -0pi -e 's/return self\._screensaver is None or self\._screensaver\.connected/return True/' src/usbguard_gui/device_dialog.py
    perl -0pi -e 's/\n        if self\._screensaver is not None and not self\._screensaver\.connected:\n(?:.*?\n)*?            return True//' src/usbguard_gui/device_dialog.py
    perl -0pi -e 's/\n        if self\._screensaver is not None and not self\._screensaver\.connected:\n(?:.*?\n)*?            return//' src/usbguard_gui/device_list.py
    perl -0pi -e 's/    def _on_lock_availability_changed\(self, available: bool\) -> None:\n(?:.*?\n)*?    def _connect_client_signals/    def _on_lock_availability_changed(self, available: bool) -> None:\n        self._lock_available = available\n\n    def _connect_client_signals/' src/usbguard_gui/app.py
  '';

  postInstall = ''
    install -Dm644 rpm/usbguard_gui.svg $out/share/icons/hicolor/scalable/apps/usbguard_gui.svg
    install -Dm644 rpm/usbguard_gui.desktop $out/share/applications/usbguard_gui.desktop
  '';

  meta = with lib; {
    description = "Qt system tray GUI for USBGuard - allow/block/reject USB devices";
    homepage = "https://github.com/gunchev/usbguard_gui";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "usbguard_gui";
  };
}
