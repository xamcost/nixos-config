{ pkgs, ... }:
{
  imports = [
    ../../cli
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    bmon # Bandwidth monitor
    gdu # Disk usage analyzer
    gettext # For envsubst
    git
    imagemagick # For image.nvim
    lua-language-server
    nerd-fonts.mononoki
    tmux
    wget
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
  };
}
