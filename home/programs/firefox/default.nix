{
  config,
  pkgs,
  inputs,
  ...
} :
let
  profile-name = "quinnieboi";
  firefox-profile = ".mozilla/firefox/${profile-name}/chrome";
in {
    # Add Firefox GNOME theme directory
    # home.file."firefox-gnome-theme" = {
    #       target = firefox-profile;
    #       source = (fetchTarball "https://github.com/rafaelmardojai/firefox-gnome-theme/archive/master.tar.gz");
    # };

    home.file."${firefox-profile}/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
    home.file."${firefox-profile}/customChrome.css".source = ./customChrome.css;
    home.file."${firefox-profile}/customContent.css".source = ./customContent.css;

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
          
          extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
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
