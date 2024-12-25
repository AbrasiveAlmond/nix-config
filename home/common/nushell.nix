{
	programs.nushell = {
		enable = true;

		envFile.text = ''
			mkdir ~/.cache/starship
			starship init nu | save -f ~/.cache/starship/init.nu

			zoxide init nushell --cmd cd | save -f ~/.zoxide.nu
		'';

		configFile.text = ''
			$env.config = {
				show_banner: false
				color_config: {
					shape_garbage: "red_underline"
					shape_external: "blue"
					shape_externalarg: "light_cyan"
				}
			}

			$env.LS_COLORS = (vivid generate tokyonight-night | str trim)
			$env.EDITOR = "nvim"

			use ~/.cache/starship/init.nu
			source ~/.zoxide.nu

			nitch
		'';
	};
}
