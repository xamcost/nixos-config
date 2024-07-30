{
  programs.nixvim = {
    plugins.oil = {
      enable = true;

      settings = {
	default_file_explorer = true;
	delete_to_trash = true;
	skip_confirm_for_simple_edits = false;
	view_options = {
	  show_hidden = true;
	  natural_order = true;
	};
	float = {
	  padding = 2;
	  max_width = 90;
	  max_height = 0;
	};
	win_options = {
	  wrap = true;
	  winblend = 0;
	};
	keymaps = {
	  "<C-c>" = false;
	  "q" = "actions.close";
	};
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<CMD>Oil<CR>";
        options = {desc = "Open parent directory";};
      }
    ];
  };
}
