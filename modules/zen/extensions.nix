{ lib, config, ... }:
{
  nav-bar = [ ];

  unified-extensions-area = [
    "ublock0_raymondhill_net-browser-action"
    "addon_darkreader_org-browser-action"
    "_91aa3897-2634-4a8a-9092-279db23a7689_-browser-action"
    "sponsorblock_ajay_app-browser-action"
    "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
  ];

  extensionSettings = {
    "*" = {
      blocked_install_message = "Addon is not added in the nix config";
      installation_mode = "blocked";
    };
    "uBlock0@raymondhill.net" = {
      private_browsing = true;
      default_area = "menupanel";
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    };
    "addon@darkreader.org" = {
      private_browsing = true;
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
    };
    "{91aa3897-2634-4a8a-9092-279db23a7689}" = {
      private_browsing = true;
      default_area = "menupanel";
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/zen-internet/latest.xpi";
    };
    "sponsorBlocker@ajay.app" = {
      private_browsing = true;
      default_area = "menupanel";
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
    };
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
      private_browsing = true;
      default_area = "menupanel";
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
    };
  };

  extensionConfig = {
    "uBlock0@raymondhill.net" = {
      advancedSettings = [
        [
          "userResourcesLocation"
          "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js"
        ]
      ];
      adminSettings = {
        userFilters = lib.concatMapStrings (x: x + "\n") [
          "twitch.tv##+js(twitch-videoad)"
          "||1337x.vpnonly.site"
          "||snowvan.xyz^"
        ];
        userSettings = rec {
          uiTheme = "dark";
          uiAccentCustom = true;
          cloudStorageEnabled = lib.mkForce false;
          advancedUserEnabled = true;
          userFiltersTrusted = true;
          importedLists = [
            "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
          ];
          externalLists = lib.concatStringsSep "\n" importedLists;
          popupPanelSections = 31;
        };
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "easylist"
          "adguard-generic"
          "adguard-mobile"
          "easyprivacy"
          "adguard-spyware"
          "adguard-spyware-url"
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "adguard-cookies"
          "ublock-cookies-adguard"
          "fanboy-social"
          "adguard-social"
          "fanboy-thirdparty_social"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "easylist-annoyances"
          "adguard-mobile-app-banners"
          "adguard-other-annoyances"
          "adguard-popup-overlays"
          "adguard-widgets"
          "ublock-annoyances"
          "DEU-0"
          "FRA-0"
          "NLD-0"
          "RUS-0"
          "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
          "user-filters"
        ];
      };
    };
    "addon@darkreader.org" = {
      enabled = true;
      automation = {
        enabled = true;
        behavior = "OnOff";
        mode = "system";
      };
      detectDarkTheme = true;
      enabledByDefault = true;
      changeBrowserTheme = true;
      enableForProtectedPages = true;
      fetchNews = true;
      syncSitesFixes = true;
      previewNewDesign = true;

      theme = {
        mode = 1;
        brightness = 100;
        contrast = 100;
        grayscale = 0;
        sepia = 0;
        useFont = false;
        fontFamily = "Dejavu Sans Mono";
        textStroke = 0;
        engine = "staticTheme";
        stylesheet = "";
        scrollbarColor = "";
        styleSystemControls = true;
        lightColorScheme = "Default";
        darkColorScheme = "Default";
        immediateModify = false;
      };
    };
  };
}
