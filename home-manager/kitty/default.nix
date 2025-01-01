{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    theme = "Tokyo Night Moon";
    # See all available kitty themes at: https://github.com/kovidgoyal/kitty-themes/blob/46d9dfe230f315a6a0c62f4687f6b3da20fd05e4/themes.json
    settings = {
      font_family = "Mononoki Nerd Font";
      font_size = 12;
      macos_option_as_alt = true;
  };
}
