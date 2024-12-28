{ config, pkgs, ... } :

let
  # Thanks: https://github.com/DanielFGray/dotfiles/blob/master/tmux.remote.conf
in {
  programs.tmux = {
    enable = true;
    shortcut = "q";
    escapeTime = 10;
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 50000;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      # {
      #   plugin = tmuxPlugins.catppuccin;
      #     extraConfig = ''
      #       set -g @catppuccin_flavour 'frappe'
      #       set -g @catppuccin_window_tabs enabled on
      #       set -g @catppeccin_date_time "%H:%M"
      #     '';
      # }
    ];

    extraConfig = with pkgs.tmuxPlugins;
    ''
      # Plugins
      # run-shell '${copycat}/share/tmux-plugins/copycat/copycat.tmux'
      run-shell '${sensible}/share/tmux-plugins/sensible/sensible.tmux'
      run-shell '${vim-tmux-navigator}/share/tmux-plugins/sensible/sensible.tmux'
      #run-shell '${urlview}/share/tmux-plugins/urlview/urlview.tmux'

      #bind-key R run-shell ' \
      #  tmux source-file /etc/tmux.conf > /dev/null; \
      #  tmux display-message "sourced /etc/tmux.conf"'

      # Be faster switching windows
      bind C-n next-window
      bind C-p previous-window

      # Send the bracketed paste mode when pasting
      bind ] paste-buffer -p

      # set-option -g set-titles on

      # Force true colors
      set-option -ga terminal-overrides ",*:Tc"

      set-option -g mouse on
      set-option -g focus-events on

      # Stay in same directory when split
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

    '';
  };

  # home.packages = with pkgs.tmuxPlugins; = [
  #  sensible
  # ];
}