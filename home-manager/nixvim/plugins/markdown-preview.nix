{ homeConfigName, ... }:
let isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" "xamcost@elysium" ];
in {
  programs.nixvim = {
    plugins.markdown-preview = {
      enable = isEnabled;
      settings = {
        command_for_global = 1;
      };
    };

    keymaps = if isEnabled then [
      {
	mode = "n";
	key = "<leader>mp";
	action = ":MarkdownPreviewToggle<CR>";
	options.desc = "Toggle Markdown Preview";
      }
    ] else [];
  };
}
