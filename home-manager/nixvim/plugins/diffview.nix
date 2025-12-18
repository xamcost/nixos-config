{ config, lib, ... }:
{
  programs.nixvim = {
    plugins.diffview = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>gdm";
        action = "<CMD>DiffviewOpen main HEAD<CR>";
        options = {
          desc = "main .. HEAD";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gdo";
        action = "<CMD>DiffviewOpen<CR>";
        options = {
          desc = "current index";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gdF";
        action = "<CMD>DiffviewFileHistory<CR>";
        options = {
          desc = "file history (branch)";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gdf";
        action = "<CMD>DiffviewFileHistory %<CR>";
        options = {
          desc = "file history (current file)";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gdc";
        action = "<CMD>DiffviewClose<CR>";
        options = {
          desc = "Close";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gdt";
        action = "<CMD>DiffviewToggleFiles<CR>";
        options = {
          desc = "Toggle Files Panel";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gde";
        action = "<CMD>DiffviewFocusFiles<CR>";
        options = {
          desc = "Focus Files Panel";
          silent = true;
        };
      }
    ];

    plugins.which-key.settings.spec = lib.mkIf config.programs.nixvim.plugins.diffview.enable [
      {
        __unkeyed-1 = "<leader>gd";
        mode = "n";
        icon = " ";
        group = "Diffview";
      }
    ];
  };
}
