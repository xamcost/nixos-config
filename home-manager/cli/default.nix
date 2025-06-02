{ pkgs, inputs, ... }: {
  imports = [ ./starship ./tmux ./zsh ];

  programs = {
    git = {
      enable = true;
      userName = "xamcost";
      userEmail = "xamcost@xam.simplelogin.com";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      defaultOptions = [ "--preview 'bat --color=always {}'" ];
    };

    ripgrep = { enable = true; };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = { enable = true; };

    lazygit = { enable = true; };

    fastfetch = { enable = true; };

    jq = { enable = true; };

    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "auto";
      icons = "auto";
      git = true;
    };
  };
}
