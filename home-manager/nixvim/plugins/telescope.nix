{ pkgs, ... }: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options = { desc = "Find files"; };
        };
        "<leader>fF" = {
          action = "find_files hidden=true";
          options.desc = "Find project files";
        };
        "<leader>fw" = {
          action = "live_grep";
          options = { desc = "Live grep"; };
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
          mode = [ "n" "i" ];
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

      settings.defaults = {
        prompt_prefix = "   ";
        color_devicons = true;
        set_env.COLORTERM = "truecolor";

        mappings = {
          i = {
            "<c-t>".__raw = ''
              function(...)
                require("trouble.sources.telescope").open(...);
              end
            '';
          };
          n = {
            "<c-t>".__raw = ''
              function(...)
                require("trouble.sources.telescope").open(...);
              end
            '';
          };
        };
      };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "telescope-heading";
        src = pkgs.fetchFromGitHub {
          owner = "crispgm";
          repo = "telescope-heading.nvim";
          rev = "v0.7.0";
          hash = "sha256-1dSGm+FQ/xb4CRPzI4Fc/bq1XyW54MOWCEddBnSsYCU=";
        };
      })
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>mh";
        action = "<cmd>Telescope heading<CR>";
        options.desc = "Markdown headers";
      }
      {
        mode = "n";
        key = "<leader>fm";
        action.__raw = ''
          function()
            require("telescope.builtin").lsp_document_symbols({symbols={"method", "function"}});
          end
        '';
        options.desc = "Document Functions";
      }
      {
        mode = "n";
        key = "<leader>fM";
        action.__raw = ''
          function()
            require("telescope.builtin").lsp_workspace_symbols({symbols={"method", "function"}});
          end
        '';
        options.desc = "Workspace Functions";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action.__raw = ''
          function()
            require("telescope.builtin").lsp_document_symbols({symbols={"class", "struct"}});
          end
        '';
        options.desc = "Document Classes";
      }
      {
        mode = "n";
        key = "<leader>fC";
        action.__raw = ''
          function()
            require("telescope.builtin").lsp_workspace_symbols({symbols={"class", "struct"}});
          end
        '';
        options.desc = "Workspace Classes";
      }
    ];
  };
}
