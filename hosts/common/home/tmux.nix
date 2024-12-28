{ pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		shortcut = "s";
		keyMode = "vi";
		mouse = true;
		shell = "${pkgs.nushell}/bin/nu";
		# terminal = "xterm-kitty";
		plugins = with pkgs; [
			tmuxPlugins.vim-tmux-navigator
		];
		# extraConfig = ''
		# 	set -g @alt_blue '#3b4261'
		# 	set -g @hl '#283457'
		# 	set -g @bg_hl '#292e42'
		# 	set -g @light_bg_hl '#1f2233'

		# 	set -g mode-style 'bg=#{@hl}'
		# 	set -g message-style 'bg=black, fg=white'
		# 	set -g status-justify centre
		# 	set -g status-style 'bg=black'

		# 	setw -g window-status-current-format '#[bg=black, fg=blue]#[bg=blue, fg=black] #I #[bg=#{@alt_blue}, fg=blue] #W #[bg=black, fg=#{@alt_blue}]'
		# 	setw -g window-status-format '#[bg=black fg=#{@bg_hl}]#[bg=#{@bg_hl}, fg=white] #I #[bg=#{@light_bg_hl} fg=#{@bg_hl}]#[bg=#{@light_bg_hl}, fg=white] #W #[bg=black, fg=#{@light_bg_hl}]'
		# 	setw -g window-status-separator ' '

		# 	set -g status-left-length 50
		# 	set -g status-left '#[bg=#{?client_prefix,magenta,blue}, fg=black] #S #[bg=black, fg=#{?client_prefix,magenta,blue}]'
		# 	set -g status-right '#[bg=black, fg=#{@alt_blue}]#[bg=#{@alt_blue}, fg=blue] %a %b %-d #[bg=blue, fg=black] %-I:%M %p '
		# '';
	};
}
