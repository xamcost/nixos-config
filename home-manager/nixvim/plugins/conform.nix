{ lib, pkgs, homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [
    "xam@aeneas"
  ];
in
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = isEnabled;

      settings = {
        format_on_save.__raw = ''
          function(bufnr)
            local disabled_filetypes = {}

            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

             -- Disable autoformat for some filetypes
            if vim.tbl_contains(disabled_filetypes, vim.bo[bufnr].filetype) then
              return
            end

            return { timeout_ms = 200, lsp_fallback = true }
           end
        '';
        notify_on_error = true;

        # Conform will run multiple formatters sequentially
        # [ "1" "2" "3"]
        # Add stop_after_first to run only the first available formatter
        # { "__unkeyed-1" = "foo"; "__unkeyed-2" = "bar"; stop_after_first = true; }
        # Use the "*" filetype to run formatters on all filetypes.
        # Use the "_" filetype to run formatters on filetypes that don't
        # have other formatters configured.
        formatters_by_ft = {
          "_" = [ "trim_whitespace" ];
          bash = [ "shfmt" ];
          css = [ "prettierd" ];
          html = [ "prettierd" ];
          javascript = [ "prettierd" ];
          javascriptreact = [ "prettierd" ];
          json = [ "jq" ];
          lua = [ "stylua" ];
          markdown = [ "prettierd" ];
          python = [ "black" "isort" ];
          nix = [ "nixfmt" ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
          terraform = [ "terraform_fmt" ];
          typescript = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
        };

        formatters = {
          black = {
            command = lib.getExe pkgs.black;
          };
          isort = {
            command = lib.getExe pkgs.isort;
          };
          prettierd = {
            command = lib.getExe pkgs.prettierd;
            prepend_args = [
              "--no-semi"
              "--single-quote"
              "--jsx-single-quote"
            ];
          };
        };
      };

    };

    keymaps = if isEnabled then [
      {
        action.__raw = ''
          function(args)
           vim.cmd({cmd = 'Conform', args = args});
          end
        '';
        mode = "v";
        key = "<leader>lf";
        options = {
          silent = true;
          buffer = false;
          desc = "Format selection";
        };
      }
      {
        action.__raw = ''
          function()
            vim.cmd('Conform');
          end
        '';
        key = "<leader>lf";
        options = {
          silent = true;
          desc = "Format buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>lt";
        action = ":FormatToggle<CR>";
        options = { desc = "Toggle format-on-save"; };
      }
    ] else [];

    userCommands = if isEnabled then {
      FormatDisable = {
        bang = true;
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = true
              vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
            else
              vim.g.disable_autoformat = true
              vim.notify("Automatic formatting on save is now disabled.", vim.log.levels.INFO)
            end
          end
        '';
        desc = "Disable automatic formatting on save";
      };

      FormatEnable = {
        bang = true;
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = false
              vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
            else
              vim.g.disable_autoformat = false
              vim.notify("Automatic formatting on save is now enabled.", vim.log.levels.INFO)
            end
          end
        '';
        desc = "Enable automatic formatting on save";
      };

      FormatToggle = {
        bang = true;
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = not vim.b.disable_autoformat

              if not vim.b.disable_autoformat then
                vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
              else
                vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
              end
            else
              vim.g.disable_autoformat = not vim.g.disable_autoformat

              if not vim.g.disable_autoformat then
                vim.notify("Automatic formatting on save is now enabled.", vim.log.levels.INFO)
              else
                vim.notify("Automatic formatting on save is now disabled.", vim.log.levels.INFO)
              end
            end
          end
        '';
        desc = "Toggle automatic formatting on save";
      };
    } else {};
  };
}
