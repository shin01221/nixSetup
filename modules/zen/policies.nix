{ lib, config, ... }:
let
  extensions = import ./extensions.nix { inherit lib config; };
in
{
  AllowFileSelectionDialogs = true;
  AppAutoUpdate = false;
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  #AutoLaunchProtocolsFromOrigins = { };
  BackgroundAppUpdate = false;
  BlockAboutAddons = false;
  BlockAboutConfig = false;
  BlockAboutProfiles = false;
  BlockAboutSupport = false;
  #Containers = { };
  DisableAppUpdate = true;
  DisableFirefoxAccounts = true;
  DisableFirefoxScreenshots = true;
  DisableFirefoxStudies = true;
  DisableFormHistory = true;
  DisableMasterPasswordCreation = true;
  DisablePocket = true;
  DisablePrivateBrowsing = false;
  DisableProfileImport = false;
  DisableProfileRefresh = false;
  DisableSafeMode = false;
  DisableTelemetry = true;
  DisableFeedbackCommands = true;
  DontCheckDefaultBrowser = true;
  DNSOverHTTPS = {
    Enabled = false;
  };
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
  };
  EncryptedMediaExtensions = {
    Enabled = true;
  };
  ExtensionUpdate = true;
  FirefoxHome = {
    Search = false;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Pocket = false;
    SponsoredPocket = false;
    Snippets = false;
    Locked = false;
  };
  HardwareAcceleration = true;
  ManualAppUpdateOnly = true;
  NoDefaultBookmarks = false;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  PictureInPicture = {
    Enabled = true;
  };
  PopupBlocking = {
    Allow = [ ];
    Default = true;
  };
  Preferences = {
    "browser.tabs.warnOnClose" = {
      Value = false;
    };
  };
  PromptForDownloadLocation = true;
  SearchSuggestEnabled = false;
  ShowHomeButton = false;
  StartDownloadsInTempDirectory = false;
  UserMessaging = {
    ExtensionRecommendations = false;
    SkipOnboarding = true;
  };
  Proxy = let
    pacContent = ''
      function FindProxyForURL(url, host) {
        var proxied = ["nix.dev", "protondb.com", "protonvpn.com", "proton.me", "protonmail.com", "protonstatus.com"];
        for (var i = 0; i < proxied.length; i++) {
          if (dnsDomainIs(host, proxied[i]) || host == proxied[i]) {
            return "SOCKS5 127.0.0.1:9050";
          }
        }
        return "DIRECT";
      }
    '';
    urlEncoded = builtins.replaceStrings
      ["%" "\n" "\r" " " "\""]
      ["%25" "%0A" "%0D" "%20" "%22"]
      pacContent;
  in {
    Mode = "autoConfig";
    AutoConfigURL = "data:application/x-ns-proxy-autoconfig,${urlEncoded}";
    Locked = false;
  };
  ExtensionSettings = extensions.extensionSettings;
  "3rdparty".Extensions = extensions.extensionConfig;
}