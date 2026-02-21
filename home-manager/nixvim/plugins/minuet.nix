{
  homeConfigName,
  ...
}:
let
  # isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" ];
  isEnabled = false;
in
{
  programs.nixvim = {
    plugins.minuet = {
      enable = isEnabled;

      settings = {
        provider = "openai_fim_compatible";
        n_completions = 1; # 1 For local model to save resources
        context_window = 2048; # Context window size for the model
        throttle = 1000; # Sends the request every x ms, 0 to disable
        debounce = 500; # Wait time after typing stops before requesting, 0 to disable
        request_timeout = 30;
        provider_options = {
          openai_fim_compatible = {
            name = "Ollama";
            api_key = "TERM";
            end_point = "http://localhost:11434/v1/completions";
            model = "deepseek-coder-v2:16b";
            # model = "qwen2.5-coder:7b";
            optional = {
              max_tokens = 256;
              stop = [ "\n\n" ];
              top_p = 0.9; # Nucleus sampling parameter, 0.9 means only the tokens comprising the top 90% probability mass are considered.
              temperature = 0.2; # Sampling temperature, higher values (e.g., 0.8) make output more random, while lower values (e.g., 0.2) make it more focused and deterministic.
            };
            stream = false;
            # template = {
            #   prompt.__raw = ''
            #     function(context_before_cursor, context_after_cursor, _)
            #       return '<|fim_prefix|>'
            #         .. context_before_cursor
            #         .. '<|fim_suffix|>'
            #         .. context_after_cursor
            #         .. '<|fim_middle|>'
            #     end
            #   '';
            #   suffix = false;
            # };
          };
        };
        virtualtext = {
          auto_trigger_ft = [ "*" ];
          keymap = {
            # accept = "<Tab>";
            # accept_line = "<C-y>";
            # next = "<C-n>";
            # prev = "<C-p>";
            # dismiss = "<C-e>";
            accept = "<M-l>";
            accept_line = "<M-;>";
            next = "<M-.>";
            prev = "<M-,>";
            dismiss = "<M-/>";
          };
        };
      };
    };
  };
}
