{ inputs, ... }: {
  imports = [
    ./starship
    ./tmux
    ./zsh
  ];

  programs = {
    git = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      defaultOptions = [ "--preview 'bat --color=always {}'" ];
    };

    ripgrep = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    fastfetch = {
      enable = true;
    };

    jq = {
      enable = true;
    };
  };
}
