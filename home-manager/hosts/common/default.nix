{ pkgs, ... }: {
  imports = [
    ../../cli
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.mononoki
    git
    tmux
    vim
    wget
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
  };
}
