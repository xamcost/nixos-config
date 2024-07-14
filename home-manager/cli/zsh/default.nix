{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 50000;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "lg" = "lazygit";
    };
  };

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      defaultOptions = ["--preview 'bat --color=always {}'"];
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
    };
  };
}
