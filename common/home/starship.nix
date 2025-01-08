{
	#      the standard path under ~/.config/
	#           to find the file       Where the file is located relative to this .nix file
	#                    |                             |
	#                    V                             V
	xdg.configFile."starship.toml".source = ./starship-pure.toml;

  programs.starship = {
    enable = true;
		enableNushellIntegration= true;
  };
}
