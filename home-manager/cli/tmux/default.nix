{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    historyLimit = 5000;
    aggressiveResize = true;
    extraConfig = ''
      # General options
      set-option -g renumber-windows on
      # Start index of window/pane with 1, because we're humans, not computers
      set -g base-index 1
      setw -g pane-base-index 1

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
    '';
  };
}
