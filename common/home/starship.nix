{
	xdg.configFile."starship.toml".source = ./starship-pure.toml;

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    # Commands to run in interactive shells.
    # using .bashrc will run even in non-interactive shells.
    initExtra = ''eval "$(starship init bash)"'';
  };
}
