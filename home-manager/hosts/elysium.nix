{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../cli
  ];

  home.username = "xamcost";
  home.homeDirectory = "/home/xamcost";

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

