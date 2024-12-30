{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    terminal = "tmux-256color";
    historyLimit = 5000;
    aggressiveResize = true;
    mouse = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.prefix-highlight;
	extraConfig = ''
	  set -g @prefix_highlight_show_copy_mode 'on'
	  set -g @prefix_highlight_copy_mode_attr 'fg=default,bg=purple'
	'';
      }
      {
	plugin = tmuxPlugins.sidebar;
	extraConfig = ''
	  set -g @sidebar-tree 't'
	  set -g @sidebar-tree-focus 'T'
	  set -g @sidebar-tree-command 'tree -C'
	'';
      }
      tmuxPlugins.sysstat
      {
        plugin = tmuxPlugins.open;
	extraConfig = ''
	  set -g @open-S 'https://www.duckduckgo.com/?q='
	'';
      }
      tmuxPlugins.tokyo-night-tmux
    ];
    extraConfig = ''
      # General options
      set-option -g renumber-windows on

      # Vim like pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # new window and retain cwd
      bind c new-window -c "#{pane_current_path}"

      # Rename session and window
      bind r command-prompt -I "#{window_name}" "rename-window '%%'"
      bind R command-prompt -I "#{session_name}" "rename-session '%%'"

      # Split panes
      bind | split-window -h -c "#{pane_current_path}"
      bind _ split-window -v -c "#{pane_current_path}"

      # Select pane and windows
      unbind [
      unbind ]
      bind -r C-[ previous-window
      bind -r C-] next-window
      bind -r [ select-pane -t :.-
      bind -r ] select-pane -t :.+
      bind -r Tab last-window   # cycle thru MRU tabs
      bind -r C-o swap-pane -D

      # Kill pane/window/session shortcuts
      bind x kill-pane
      bind X kill-window
      bind C-x confirm-before -p "kill other windows? (y/n)" "kill-window -a"
      bind Q confirm-before -p "kill-session #S? (y/n)" kill-session

      # Hide status bar on demand
      bind C-s if -F '#{s/off//:status}' 'set status off' 'set status on'

      # https://github.com/3rd/image.nvim/?tab=readme-ov-file#tmux
      # This is needed by the image.nvim plugin
      set -gq allow-passthrough on

      # ================================================
      # ===     Copy mode, scroll and clipboard      ===
      # ================================================

      set -g @copy_use_osc52_fallback on

      # Prefer vi style key table
      setw -g mode-keys vi

      bind p paste-buffer
      bind C-p choose-buffer

      # trigger copy mode by
      bind -n M-Up copy-mode

      # =====================================
      # ===    Appearence and status bar  ===
      # =====================================

      # general status bar settings
      set -g status on
      set -g status-interval 5
      set -g status-position top
      set -g status-justify left
      set -g status-right-length 100

      set -g status-right "#{prefix_highlight} #{sysstat_cpu} | #{sysstat_mem} | #{sysstat_swap} | #{sysstat_loadavg} | #[fg=cyan]#(echo $USER)#[default]@#H"

      # ===============================
      # ===    Run plugins scripts  ===
      # ===============================

      run-shell ${pkgs.tmuxPlugins.sysstat}/share/tmux-plugins/sysstat/sysstat.tmux
      run-shell ${pkgs.tmuxPlugins.prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux
    '';
  };
}
