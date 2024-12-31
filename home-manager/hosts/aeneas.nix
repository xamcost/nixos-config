{
  imports = [
    ../cli
    ../nixvim
  ];

  home.username = "xam";
  home.homeDirectory = "/home/xam";

  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

