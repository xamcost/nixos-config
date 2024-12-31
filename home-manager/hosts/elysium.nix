{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./common
    ../nixvim
  ];

  home.username = "xamcost";
  home.homeDirectory = "/home/xamcost";

  home.stateVersion = "24.05";
}

