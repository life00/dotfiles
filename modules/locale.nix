{ pkgs, ... }:
{
  time.timeZone = "Europe/Prague";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # ponytail: format must be `xx_XX.UTF-8/UTF-8` (matches glibc's
    # localedata/SUPPORTED exactly); plain `xx_XX.UTF-8` fails the
    # build-time check in glibc's locales derivation.
    extraLocales = [ "uk_UA.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
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
