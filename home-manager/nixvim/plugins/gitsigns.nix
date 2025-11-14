{ config, lib, ... }:
{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      settings = {
        trouble = true;
        current_line_blame = false;
        current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>";
        signs = {
          add = {
            text = "│";
          };
          change = {
            text = "│";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
          untracked = {
            text = "│";
          };
        };
      };
    };

    keymaps = lib.mkIf config.programs.nixvim.plugins.gitsigns.enable [
      {
        mode = "n";
        key = "<leader>gb";
        action = ":Gitsigns blame_line<CR>";
        options = {
          silent = true;
          desc = "Blame line";
        };
      }
      {
        mode = "n";
        key = "<leader>gdi";
        action = ":Gitsigns diffthis<CR>";
        options = {
          silent = true;
          desc = "Diff This Index";
        };
      }
      {
        mode = "n";
        key = "<leader>gR";
        action = ":Gitsigns reset_buffer<CR>";
        options = {
          silent = true;
          desc = "Reset Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>gS";
        action = ":Gitsigns stage_buffer<CR>";
        options = {
          silent = true;
          desc = "Stage Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>ghp";
        action = ":Gitsigns preview_hunk_inline<CR>";
        options = {
          silent = true;
          desc = "Preview";
        };
      }
      {
        mode = "n";
        key = "<leader>ghr";
        action = ":Gitsigns reset_hunk<CR>";
        options = {
          silent = true;
          desc = "Reset";
        };
      }
      {
        mode = "n";
        key = "<leader>ghs";
        action = ":Gitsigns stage_hunk<CR>";
        options = {
          silent = true;
          desc = "Stage";
        };
      }
      {
        mode = "n";
        key = "<leader>ghu";
        action = ":Gitsigns undo_stage_hunk<CR>";
        options = {
          silent = true;
          desc = "Undo Stage";
        };
      }
      {
        mode = "n";
        key = "[g";
        action = ":Gitsigns prev_hunk<CR>";
        options = {
          silent = true;
          desc = "Previous";
        };
      }
      {
        mode = "n";
        key = "]g";
        action = ":Gitsigns next_hunk<CR>";
        options = {
          silent = true;
          desc = "Next";
        };
      }
    ];

    plugins.which-key.settings.spec = lib.mkIf config.programs.nixvim.plugins.gitsigns.enable [
      {
        __unkeyed-1 = "<leader>gh";
        mode = "n";
        icon = " ";
        group = "Hunks";
      }
    ];
  };
}
