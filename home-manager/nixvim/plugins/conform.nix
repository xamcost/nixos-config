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
	    if not (vim.g.autoformat or vim.b[bufnr].autoformat) then
	      return
	    end

	    return { timeout_ms = 500, lsp_format = "fallback" }
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
        mode = "n";
        key = "<leader>lf";
        action = {
          __raw = ''
            function() require("conform").format({ async = true, lsp_fallback = true }) end'';
        };
        options = { desc = "Format"; };
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
              vim.b.autoformat = false
              vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
            else
              vim.g.autoformat = false
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
              vim.b.autoformat = true
              vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
            else
              vim.g.autoformat = true
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
              vim.b.autoformat = not vim.b.autoformat

              if vim.b.autoformat then
          vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
              else
          vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
              end
            else
              vim.g.autoformat = not vim.g.autoformat

              if vim.g.autoformat then
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
