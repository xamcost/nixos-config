{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../../home-manager
  ];

  home.username = "xamcost";
  home.homeDirectory = "/home/xamcost";

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
