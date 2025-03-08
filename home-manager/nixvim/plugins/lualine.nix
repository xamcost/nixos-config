{ homeConfigName, ... }:
let isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" ];
in {
  programs.nixvim = {
    plugins.lualine = {
      enable = isEnabled;
      settings = {
        theme = "auto";
        globalstatus = true;
        disabled_filetypes = { statusline = [ "dashboard" "alpha" "starter" "snacks_dashboard" ]; };
	sections = {
	  "lualine_a" = [ "mode" ];
	  "lualine_b" = [
	    "branch"
	  ];
	  "lualine_c" = [
	    {
	      __unkeyed = "diagnostics";
	      symbols = {
		error = " ";
		warn = " ";
		info = " ";
		hint = " ";
	      };
	    }
	    {
	      __unkeyed = "filetype";
	      icon_only = true;
	      separator.left = "";
	      separator.right = "";
	      padding = { left = 1; right = 0; };
	    }
	    {
	      __unkeyed = "filename";
	      path = 1;
	    }
	  ];
	  "lualine_x" = [
	    {
	      __unkeyed = "diff";
	      separator.left = "";
	      separator.right = "";
	      symbols = {
		added = " ";
		modified = " ";
		removed = " ";
	      };
	    }
	  ];
	  "lualine_y" = [
	    # Show all active language servers
	    {
	      __unkeyed.__raw = ''
		function()
		  local bufnr = vim.api.nvim_get_current_buf()
		  local clients = vim.lsp.buf_get_clients(bufnr)
		  if next(clients) == nil then
		    return ""
		  end

		  local c = {}
		  for _, client in pairs(clients) do
		    if client.name ~= 'copilot' then
		      table.insert(c, client.name)
		    end
		  end
		  return table.concat(c, ' | ')
		end
	      '';
	      icons_enabled = true;
	      icon = "";
	      color.fg = "#ffffff";
	    }
	  ];
	  "lualine_z" = [
	    {
	      __unkeyed = "progress";
	      separator.left = " ";
	      separator.right = " ";
	      padding = { left = 1; right = 0; };
            }
	    {
	      __unkeyed = "location";
	      separator.left = "";
	      separator.right = "";
	      padding = { left = 0; right = 1; };
            }
	  ];
	};
      };
    };
  };
}
