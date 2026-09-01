{ ... }:
{
  time.timeZone = "Europe/Prague";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "uk_UA.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  console = {
    font = "latarcyrheb-sun32";
    keyMap = "us";
  };

  # custom mechanical keyboard xkb layout
  services.xserver.xkb.extraLayouts = {
    custom-mech = {
      description = "Custom mechanical keyboard layout (Win/Alt/Ctrl + arrow remap)";
      languages = [ "eng" ];
      symbolsFile = ./xkb/custom-mech;
    };
  };
}
