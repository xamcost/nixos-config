{
  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = true;
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
      };
      experimental = {
        disable_paste_summary = true;
      };
    };
    tui = {
      theme = "tokyonight";
    };
  };
}
