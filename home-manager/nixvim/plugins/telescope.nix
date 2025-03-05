{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find files";
          };
        };
        "<leader>fF" = {
          action = "find_files hidden=true";
          options.desc = "Find project files";
        };
        "<leader>fw" = {
          action = "live_grep";
          options = {
            desc = "Live grep";
          };
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent";
        };
        "<leader>f:" = {
          action = "command_history";
          options.desc = "Command History";
        };
        "<c-p>" = {
          mode = [
            "n"
            "i"
          ];
          action = "registers";
          options.desc = "Select register to paste";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "commits";
        };
        "<leader>sm" = {
          action = "man_pages";
          options.desc = "Man pages";
        };
        "<leader>sk" = {
          action = "keymaps";
          options.desc = "Keymaps";
        };
        "<leader>sh" = {
          action = "help_tags";
          options.desc = "Help pages";
        };
        "<leader>s:" = {
          action = "commands";
          options.desc = "Commands";
        };
        "<leader>sa" = {
          action = "autocommands";
          options.desc = "Auto Commands";
        };
        "<leader>ss" = {
          action = "grep_string";
          options.desc = "Word under cursor";
        };
      };
    };
  };
}
