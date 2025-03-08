{ homeConfigName, ... }:
let isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" "xamcost@elysium" ];
in {
  programs.nixvim = {
    plugins.image = {
      enable = isEnabled;
	#      backend = "kitty";
	#      editorOnlyRenderWhenFocused = true;
	#      hijackFilePatterns = [
	# "*.png"
	# "*.jpg"
	# "*.jpeg"
	# "*.webp"
	# "*.avif"
	#      ];
	#      maxHeightWindowPercentage = 40;
	#      tmuxShowOnlyInActiveWindow = true;
	#      windowOverlapClearEnabled = false;
	#      windowOverlapClearFtIgnore = [
	# "cmp_menu"
	# "cmp_docs"
	# ""
	#      ];
	#      integrations = {
	# markdown = {
	#   enabled = true;
	#   clearInInsertMode = false;
	#   downloadRemoteImages = true;
	#   filetypes = [
	#     "markdown"
	#     "vimwiki"
	#   ];
	#   onlyRenderImageAtCursor = true;
	#        };
	# neorg.enabled = false;
	#      };
    };

    extraConfigLua = if isEnabled then ''
      require('image').setup({
	backend = "kitty",
	processor = "magick_cli",
	integrations = {
	  markdown = {
	    enabled = true,
	    clear_in_insert_mode = false,
	    download_remote_images = true,
	    only_render_image_at_cursor = true,
	    filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
	    resolve_image_path = function(document_path, image_path, fallback)
	      local working_dir = vim.fn.getcwd()
	      -- Format image path for Obsidian notes
	      if (working_dir:find("Obsidian/asphodel") and not image_path:find("../", 1, true)) then
		return working_dir .. "/" .. image_path
	      end
	      -- Fallback to the default behavior
	      return fallback(document_path, image_path)
	    end,
	  },
	  neorg = {
	    enabled = false,
	    clear_in_insert_mode = false,
	    download_remote_images = true,
	    only_render_image_at_cursor = false,
	    filetypes = { "norg" },
	  },
	  html = {
	    enabled = false,
	  },
	  css = {
	    enabled = false,
	  },
	},
	max_width = nil,
	max_height = nil,
	kitty_method = "normal",
	max_width_window_percentage = nil,
	max_height_window_percentage = 40,
	window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	editor_only_render_when_focused = true,                                             -- auto show/hide images when the editor gains/looses focus
	tmux_show_only_in_active_window = true,                                             -- auto show/hide images in the correct Tmux window (needs visual-activity off)
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    '' else "";
  };
}
