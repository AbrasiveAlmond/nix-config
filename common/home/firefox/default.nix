{ config, pkgs, inputs, ... }:
let
  profile-name = "quinnieboi";
  firefox-profile = ".mozilla/firefox/${profile-name}/chrome";
in {
  home.file."${firefox-profile}/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  home.file."${firefox-profile}/customChrome.css".source = ./chrome/customChrome.css;
  home.file."${firefox-profile}/customContent.css".source = ./chrome/customContent.css;
  home.file."${firefox-profile}/gnome-sidebery.css".source = ./chrome/gnome-sidebery.css;

  programs.firefox = {
    enable = true;
    profiles.${profile-name} = {
      isDefault = true;
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
        @import "customChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
        @import "customContent.css";
      '';

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        darkreader
        sidebery
        stylus
        privacy-badger
        disconnect
        clearurls
        greasemonkey
        # browserpass
      ];

      # https://github.com/nix-community/home-manager/issues/3698#issuecomment-1442291975
      search.force = true;
      # search.default = "Kagi";
      search.engines = {
        "Kagi" = {
          urls = [{
            template = "https://kagi.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }];
        };

        "Marginalia" = {
          urls = [{
            template = "https://marginalia-search.com/search";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];
        };

        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];
          icon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "Nix Options" = {
          urls = [{
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "type";
                value = "options";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];
          icon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };

        "NixOS Wiki" = {
          urls = [{
            template = "https://nixos.wiki/index.php?search={searchTerms}";
          }];
          icon = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@nw" ];
        };

        "Home Manager Options" = {
          urls = [{
            template = "https://home-manager-options.extranix.com/";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];
          definedAliases = [ "@ho" ];
        };

        "wikipedia".metaData.alias = "@w";
        "google".metaData.hidden = true;
        "amazondotcom-us".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "ebay".metaData.hidden = true;
      };

      # almost all from https://github.com/Misterio77/nix-config/blob/main/home/gabriel/features/desktop/common/firefox.nix
      settings = {
        # prevent alt menu, freeing alt for tab navigation
        "ui.key.menuAccessKeyFocuses" = false;

        # Enable SVG context-propertes
        "svg.context-properties.content.enabled" = true;

        # Disable private window dark theme
        "browser.theme.dark-private-windows" = false;

        # Enable rounded bottom window corners
        "widget.gtk.rounded-bottom-corners.enabled" = true;

        # Set UI density to normal
        "browser.uidensity" = 0;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.homepage" = "about:home";

        # scrolls crazy fast on trackpad. this doesn't seem to change desktop behaviour.
        # weird that it defaults to true since ff91
        "mousewheel.system_scroll_override.enable" = false;

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Don't ask for download dir
        "browser.download.useDownloadDir" = false;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" =
          false;

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;

        # Give up on declarative and just spend 5 min setting it once and forgetting :)
        # Layout
        # "browser.uiCustomization.state" = builtins.toJSON {
        #   currentVersion = 20;
        #   newElementCount = 5;
        #   dirtyAreaCache = [
        #     "nav-bar"
        #     "PersonalToolbar"
        #     "toolbar-menubar"
        #     "TabsToolbar"
        #     "widget-overflow-fixed-list"
        #   ];

        #   placements = {
        #     # PersonalToolbar = ["personal-bookmarks"];
        #     # TabsToolbar = ["tabbrowser-tabs" "new-tab-button" "alltabs-button"];
        #     # # Needs spacers added due to lack of titlebar
        #     nav-bar = [
        #       "back-button"
        #       "forward-button"
        #       "stop-reload-button"
        #       "customizableui-special-spring"
        #       "customizableui-special-spring"
        #       "customizableui-special-spring"
        #       "customizableui-special-spring"
        #       "urlbar-container"
        #       "customizableui-special-spring"
        #       "customizableui-special-spring"
        #       "customizableui-special-spring"
        #       "customizableui-special-spring"
        #       "downloads-button"
        #       "ublock0_raymondhill_net-browser-action"
        #       "addon_darkreader_org-browser-action"
        #       "_3c078156-979c-498b-8990-85f7987dd929_-browser-action" # Sidebery
        #       "unified-extensions-button"
        #     ];
        #     # toolbar-menubar = ["menubar-items"];
        #     # unified-extensions-area = [ ];
        #     # widget-overflow-fixed-list = [ ];
        #   };
        #   seen = [
        #     "save-to-pocket-button"
        #     "developer-button"
        #     # "ublock0_raymondhill_net-browser-action"
        #   ];
        # };
      };
    };
  };
}
