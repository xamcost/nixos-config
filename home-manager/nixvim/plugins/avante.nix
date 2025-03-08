{ homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [
    "xam@aeneas"
  ];
in
{
  programs.nixvim = {
    plugins.avante = {
      enable = isEnabled;

      settings = {
	provider = "copilot";
	copilot = {
	  endpoint = "https://api.githubcopilot.com";
	  # model = "gpt-4o-2024-08-06";
	  model = "claude-3.7-sonnet";
	  allow_insecure = false; # Allow insecure server connections
	  timeout = 30000; # Timeout in milliseconds
	  temperature = 0;
	  max_tokens = 4096;
	};
	dual_boost = {
	  enabled = false;
	};
	behaviour = {
	  auto_suggestions = false; # Experimental stage
	  auto_set_highlight_group = true;
	  auto_set_keymaps = true;
	  auto_apply_diff_after_generation = false;
	  support_paste_from_clipboard = false;
	  minimize_diff = true; # Whether to remove unchanged lines when applying a code block
	  enable_token_counting = true; # Whether to enable token counting. Default to true.
	  enable_cursor_planning_mode = false; # Whether to enable Cursor Planning Mode. Default to false.
	};
      };
    };
  };
}
