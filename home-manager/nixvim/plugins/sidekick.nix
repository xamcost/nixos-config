{
  config,
  lib,
  homeConfigName,
  ...
}:
let
  isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" ];
in
{
  programs.nixvim = {
    plugins.sidekick = {
      enable = isEnabled;

      settings = {
        keys = { };

        cli = {
          mux = {
            enabled = true;
            backend = "tmux";

            create = "split";
            split = {
              vertical = true;
              size = 0.4;
            };
          };
        };

        nes = {
          enabled.__raw = ''
            ---@type boolean|fun(buf:integer):boolean?
            function(buf)
              if vim.bo.filetype == 'markdown' then
                return false
              end
              -- default settings
              return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
            end
          '';
        };

        # prompts = {
        #   explain = "Explain this code";
        #   optimize = "How can this code be optimized?";
        #
        #   diagnostics = {
        #     diagnostics = true;
        #     msg = "What do the diagnostics in this file mean?";
        #   };
        #
        #   diagnostics_all = {
        #     msg = "Can you help me fix these issues?";
        #
        #     diagnostics = {
        #       all = true;
        #     };
        #   };
        #
        #   fix = {
        #     msg = "Can you fix the issues in this code?";
        #     diagnostics = true;
        #   };
        #
        #   review = {
        #     msg = "Can you review this code for any issues or improvements?";
        #     diagnostics = true;
        #   };
        # };
      };
    };

    plugins.which-key.settings.spec = lib.mkIf config.programs.nixvim.plugins.sidekick.enable [
      {
        __unkeyed-1 = "<leader>as";
        mode = "n";
        icon = " ";
        group = "Sidekick";
      }
    ];

    keymaps = lib.mkIf config.programs.nixvim.plugins.sidekick.enable [
      {
        mode = "i";
        key = "<C-l>";
        action = "<cmd>lua require('sidekick').nes_jump_or_apply()<cr>";
        options = {
          desc = "Goto / Apply Next Edit Suggestion";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-y>";
        action = "<cmd>lua require('sidekick').nes_jump_or_apply()<cr>";
        options = {
          desc = "Goto / Apply Next Edit Suggestion";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asa";
        action = "<cmd>lua require('sidekick.cli').toggle()<cr>";
        options = {
          desc = "Toggle CLI";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asc";
        action = "<cmd>lua require('sidekick.cli').toggle({ name = 'copilot', focus = true })<cr>";
        options = {
          desc = "Toggle Copilot";
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>asf";
        action = "<cmd>lua require('sidekick.cli').focus()<cr>";
        options = {
          desc = "Switch Focus";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asna";
        action = "<cmd>lua require('sidekick.nes').apply()<cr>";
        options = {
          desc = "Apply Next Edit Suggestions";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asnc";
        action = "<cmd>lua require('sidekick.nes').clear()<cr>";
        options = {
          desc = "Clear Next Edit Suggestions";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asnd";
        action = "<cmd>lua require('sidekick.nes').disable()<cr>";
        options = {
          desc = "Disable Next Edit Suggestions";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asne";
        action = "<cmd>lua require('sidekick.nes').enable()<cr>";
        options = {
          desc = "Enable Next Edit Suggestions";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asnt";
        action = "<cmd>lua require('sidekick.nes').toggle()<cr>";
        options = {
          desc = "Toggle Next Edit Suggestions";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>asnu";
        action = "<cmd>lua require('sidekick.nes').update()<cr>";
        options = {
          desc = "Update Next Edit Suggestions";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>aso";
        action = "<cmd>lua require('sidekick.cli').toggle({ name = 'opencode', focus = true })<cr>";
        options = {
          desc = "Toggle OpenCode";
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>asp";
        action = "<cmd>lua require('sidekick.cli').prompt()<cr>";
        options = {
          desc = "Select Prompt";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>ass";
        action = "<cmd>lua require('sidekick.cli').select({ filter = { installed = true } })<cr>";
        options = {
          desc = "CLI";
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>ast";
        action = "<cmd>lua require('sidekick.cli').send({ msg = '{this}' })<cr>";
        options = {
          desc = "Send This";
          silent = true;
        };
      }
      {
        mode = "x";
        key = "<leader>asv";
        action = "<cmd>lua require('sidekick.cli').send({ msg = '{selection}' })<cr>";
        options = {
          desc = "Send Visual Selection";
          silent = true;
        };
      }
    ];
  };
}
