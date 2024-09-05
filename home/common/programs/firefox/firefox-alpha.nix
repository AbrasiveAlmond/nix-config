{ pkgs, lib, ... }:

let
  firefox-alpha = false;
in {
	programs.firefox = {
		enable = true;

		profiles.default = {
			settings = {
				"layout.css.devPixelsPerPx" = 1.65;
			} // lib.optionalAttrs firefox-alpha {
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
				"browser.urlbar.maxRichResults" = 0;
			};
		};
	};

	home.file = if firefox-alpha then {
		".mozilla/firefox/default/chrome" = let
			source = pkgs.fetchFromGitHub {
				owner = "Tagggar";
				repo = "Firefox-Alpha";
				rev = "7d4ad9d7b052a25d4ea70b4e19a5da6359ea6b97";
				hash = "sha256-zc/9RVFRBPFRS+5EJvCTe5wKlEQX/MnAT7gpa/DBbuY=";
			};
		in {
			source = "${source}/chrome";
		};
	} else {};
}
