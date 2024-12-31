{ pkgs, ... }: {
  imports = [
    ../../cli
  ];

  home.packages = with pkgs; [
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
