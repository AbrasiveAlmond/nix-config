let {
  profile_name = "gnome"
  firefox_profile = ".mozilla/firefox/${profile_name}/chrome/firefox-gnome-theme"
} in {
  home.file.firefox_profile.source = inputs.firefox-gnome-theme;

  programs.firefox = {
      enable = true;
      profiles.${profile_name} = {
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
          @import "customChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
          @import "customContent.css";
        '';
        
        extensions = with pkgs.inputs.firefox-addons; [
          ublock-origin
          darkreader
          vimium
          sidebery
          stylus
          privacy-badger
          disconnect
          clearurls
          # browserpass
        ];

        search.engines = {
                        "Nix Packages" = {
                            urls = [{
                                template = "https://search.nixos.org/packages";
                                params = [
                                    { name = "type"; value = "packages"; }
                                    { name = "query"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            definedAliases = [ "@np" ];
                        };
                        "NixOS Wiki" = {
                            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                            iconUpdateURL = "https://nixos.wiki/favicon.png";
                            updateInterval = 24 * 60 * 60 * 1000;
                            definedAliases = [ "@nw" ];
                        };
                        "Wikipedia (en)".metaData.alias = "@wiki";
                        "Google".metaData.hidden = true;
                        "Amazon.com".metaData.hidden = true;
                        "Bing".metaData.hidden = true;
                        "eBay".metaData.hidden = true;
                    };

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.startup.homepage" = "about:home";

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
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;

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
        };
      };
  };
}

# flake.nix
# inputs = {
#   firefox-gnome-theme = { url = "github:rafaelmardojai/firefox-gnome-theme"; flake = false; };
# };
