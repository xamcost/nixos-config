{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        # Nix
        nixd = {
	  enable = true;
	};
        # Markdown
        marksman = {
	  enable = true;
	};
      };
      keymaps = {
        diagnostic = {
          "<leader>ld" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
          "<leader>lq" = {
            action = "setloclist";
            desc = "List Diagnostics";
          };
        };
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Goto Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>lr" = {
            action = "rename";
            desc = "Rename references";
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ll";
	action = {
	  __raw = ''
	    function()
	      if vim.g.diagnostics_visible then
		vim.g.diagnostics_visible = false
		vim.diagnostic.disable()
	      else
		vim.g.diagnostics_visible = true
		vim.diagnostic.enable()
	      end
	    end
	  '';
	};
        options = {desc = "Toggle diagnostics";};
      }
    ];
  };
}

