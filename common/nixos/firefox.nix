{ ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  # https://nixos.wiki/wiki/Firefox - smooth scrolling + trackpad gestures
  environment.sessionVariables = { MOZ_USE_XINPUT2 = "1"; };

  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "de" "en-US" ];

      # ---- POLICIES ----
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar =
          "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "separate"; # alternative: "separate"

        # ---- EXTENSIONS ----
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        # ExtensionSettings = {
        #   # uBlock Origin:
        #   "uBlock0@raymondhill.net" = {
        #     install_url =
        #       "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        #     installation_mode = "normal_installed";
        #   };

        #   # Privacy Badger:
        #   "jid1-MnnxcxisBPnSXQ@jetpack" = {
        #     install_url =
        #       "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        #     installation_mode = "normal_installed";
        #   };

        #   # Sidebery:
        #   "3c078156-979c-498b-8990-85f7987dd929" = {
        #     install_url =
        #       "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
        #     installation_mode = "normal_installed";
        #   };
        # };

        # ---- PREFERENCES ----
        # can also be accessed directly but the interface doesn't allow locking.
        # programs.firefox.preferences."..." = boolean or signed integer or string;
        # Check about:config for options.
        Preferences = {
        # Make Firefox use the native KDE/Gnome file picker
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        # Disabling rando features
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "permissions.default.shortcuts" = 3; # https://support.mozilla.org/en-US/questions/1241294#answer-1175070
        "extensions.pocket.enabled" = lock-false;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" =
            lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" =
            lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" =
            lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" =
            lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" =
            lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" =
            lock-false;
        };
      };
    };
  };
}
