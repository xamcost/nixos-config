{
  lib,
  homeConfigName,
  ...
}:
let
  isEnabled = builtins.elem homeConfigName [ "maximecostalonga@xam-mac-m4" ];
  # isEnabled = false;
in
{
  programs.nixvim = {
    plugins.avante = {
      enable = isEnabled;

      settings = {
        provider = "copilot";
        mode = "agentic"; # or legacy
        auto_suggestions_provider = "ollama";
        providers = {
          copilot = {
            endpoint = "https://api.githubcopilot.com";
            model = "gpt-4.1";
            # model = "claude-3.7-sonnet";
            allow_insecure = false; # Allow insecure server connections
            timeout = 30000; # Timeout in milliseconds
            extra_request_body = {
              options = {
                temperature = 0.1;
                max_tokens = 20480;
              };

            };
          };
          ollama = {
            model = "deepseek-coder-v2:16b";
            endpoint = "http://127.0.0.1:11434"; # no /v1 at the end.
          };
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

    plugins.which-key.settings.spec = lib.mkIf isEnabled [
      {
        __unkeyed-1 = "<leader>a";
        mode = "n";
        icon = " ";
        group = "Avante";
      }
    ];
  };
}
