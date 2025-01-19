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

    historySubstringSearch = {
      enable = true;
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "cat" = "bat --style=plain";
      "lla" = "ls -lah";
      "lg" = "lazygit";
    };

    initExtra = ''
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;5D" beginning-of-line
      bindkey "^[[1;5C" end-of-line
    '';
  };
}
