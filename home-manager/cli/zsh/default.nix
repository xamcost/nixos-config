{
  programs.zsh = {
    enable = true;
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
}
