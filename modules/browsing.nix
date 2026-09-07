{ ... }:
{
  # shared chromium defaults

  programs.chromium = {
    enable = true;

    initialPrefs = {
      first_run_tabs = [ ];
    };

    extraOptsRecommended = {
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "DuckDuckGo";
      "DefaultSearchProviderSearchURL" = "https://duckduckgo.com/?q={searchTerms}";
      "DefaultSearchProviderSuggestURL" = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      "RestoreOnStartup" = 1; # continue where you left off
      "BlockThirdPartyCookies" = true;
      "DownloadRestrictions" = 1; # block automatic downloads
      "MetricsReportingEnabled" = false;
      "ozone-platform-hint" = "auto";
    };

    # locked settings
    extraOpts = {
      # "DnsOverHttpsMode" = "secure";
      # "DnsOverHttpsTemplates" = "https://dns.quad9.net/dns-query";
      "ExtensionInstallForcelist" = [
        # extensions for all profiles
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "cmpdlhmnmjhihmcfnigoememnffkimlk" # Catppuccin Macchiato theme
      ];
    };
  };
}
