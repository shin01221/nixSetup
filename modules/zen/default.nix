{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: # Sourced config into root scope
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        imports = [ inputs.zen-browser.homeModules.beta ];

        programs.zen-browser = {
          enable = true;
          policies = import ./policies.nix { inherit self lib config pkgs; };
          languagePacks = [
            "en-GB"
            "en-US"
          ];
          profiles = {
            default = {
              id = 0;
              name = "default";
              isDefault = true;
              settings = import ./settings.nix { inherit self lib config; };
              bookmarks = import ./bookmarks.nix;
              search = import ./search.nix { inherit self pkgs; };
              mods = [
                "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
                "b51ff956-6aea-47ab-80c7-d6c047c0d510" # Disable Status Bar
                "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
                "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
                "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
                "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
                "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab Panel
              ];
              userChrome = builtins.readFile ./themes/userChrome.css;
              userContent = builtins.readFile ./themes/userContent.css;
              extraConfig = ''
                ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
                ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
                ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
                ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
                lockPref("extensions.formautofill.addresses.enabled", false);
                lockPref("extensions.formautofill.creditCards.enabled", false);
                lockPref("dom.security.https_only_mode_pbm", true);
                lockPref("dom.security.https_only_mode_error_page_user_suggestions", true);
                lockPref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
                lockPref("identity.fxaccounts.enabled", false);
                lockPref("browser.tabs.firefox-view-next", false);
                lockPref("privacy.sanitize.sanitizeOnShutdown", false);
                lockPref("privacy.clearOnShutdown.cache", true);
                lockPref("privacy.clearOnShutdown.cookies", false);
                lockPref("privacy.clearOnShutdown.offlineApps", false);
                lockPref("browser.sessionstore.privacy_level", 0);
                lockPref("floorp.browser.sidebar.enable", false);
                lockPref("geo.enabled", false);
                lockPref("media.navigator.enabled", false);
                lockPref("dom.event.clipboardevents.enabled", false);
                lockPref("dom.event.contextmenu.enabled", false);
                lockPref("dom.battery.enabled", false);
                lockPref("extensions.enabledScopes", 15);
                lockPref("extensions.autoDisableScopes", 0);
                lockPref("browser.newtabpage.activity-stream.floorp.newtab.imagecredit.hide", true);
                lockPref("browser.newtabpage.activity-stream.floorp.newtab.releasenote.hide", true);
                lockPref("browser.search.separatePrivateDefault", true);
              '';
            };
          };
        };
      }
    )
  ];
}
