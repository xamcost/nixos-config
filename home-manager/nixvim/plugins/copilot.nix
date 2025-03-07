{ homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [
    "xam@aeneas"
  ];
in
{
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = isEnabled;
      settings = {
	panel = { enabled = false; };
	suggestion = {
	  enabled = true;
	  auto_trigger = true;
	  keymap = {
	    accept = "<C-l>";
	    acceptWord = false;
	    acceptLine = false;
	    next = "<M-]>";
	    prev = "<M-[>";
	    dismiss = "<M-Bslash>";
	    # next = "<C-.>";
	    # prev = "<C-,>";
	    # dismiss = "<C/>";
	  };
	};
	filetypes = {
	  markdown = true;
	  yaml = true;
	};
      };
    };
  };
}

