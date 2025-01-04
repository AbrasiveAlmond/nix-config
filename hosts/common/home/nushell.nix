{
	programs.nushell = {
		enable = true;

		envFile.text = ''
			mkdir ~/.cache/starship
			starship init nu | save -f ~/.cache/starship/init.nu
			zoxide init nushell --cmd cd | save -f ~/.zoxide.nu

			$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
      mkdir ~/.cache/carapace
      carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
		'';

		configFile.text = ''
      # let carapace_completer = {|spans|
      #   carapace $spans.0 nushell $spans | from json
      # }
      source ~/.cache/carapace/init.nu

      let zoxide_completer = {|spans|
          $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
      }
      # z => $zoxide_completer

			$env.config = {
				show_banner: false

				completions: {
        case_sensitive: false   # case-sensitive completions
        quick: true             # set to false to prevent auto-selecting completions
        partial: true           # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"      # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100
            completer: $carapace_completer # check 'carapace_completer'
          }
        }

				color_config: {
					shape_garbage: "red_underline"
					shape_external: "blue"
					shape_externalarg: "light_cyan"
				}
			}

			$env.LS_COLORS = (vivid generate gruvbox-dark-soft | str trim)
			$env.EDITOR = "nvim"

			use ~/.cache/starship/init.nu
			source ~/.zoxide.nu
		'';
	};

	programs.carapace = {
	  enable = true;
		enableNushellIntegration = true;
	};

	programs.zoxide = {
	  enable = true;
		enableNushellIntegration = true;
	};
}
