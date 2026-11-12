{
  programs.opencode = {
    enable = true;
    cli = {
      theme = {
        name = "tokyonight";
        mode = "system";
      };
    };
    settings = {
      permissions = [
        { action = "read"; resource = "*"; effect = "allow"; }
        { action = "read"; resource = "*.env"; effect = "deny"; }
        { action = "read"; resource = "*.env.*"; effect = "deny"; }
        { action = "read"; resource = "*.env.example"; effect = "allow"; }
        { action = "read"; resource = ".private/*"; effect = "deny"; }
        { action = "read"; resource = ".secrets/*"; effect = "deny"; }
        { action = "shell"; resource = "*"; effect = "ask"; }
        { action = "shell"; resource = "git status *"; effect = "allow"; }
        { action = "shell"; resource = "git diff *"; effect = "allow"; }
        { action = "shell"; resource = "git push *"; effect = "deny"; }
        { action = "skill"; resource = "*"; effect = "ask"; }
        { action = "webfetch"; resource = "*"; effect = "ask"; }
        { action = "websearch"; resource = "*"; effect = "ask"; }
      ];
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
      };
      provider = {
        omlx = {
          npm = "@ai-sdk/openai-compatible";
          name = "OMLX";
          options = {
            baseURL = "http://127.0.0.1:8080/v1";
          };
          models = {
            "mlx-community/Qwen2.5-Coder-7B-Instruct-8bit" = {
              name = "Qwen 2.5 Coder 7B Instruct 8bit";
              limit = {
                context = 32000;
                output = 32768;
              };
            };
            "mlx-community/Qwen3.5-27B-Claude-4.6-Opus-Distilled-MLX-4bit" = {
              name = "Qwen 3.5 27B Claude 4.6 Opus Distilled MLX 4bit";
              limit = {
                context = 32000;
                output = 32768;
              };
            };
          };
        };
        bsqai = {
          name = "BullSequana AI";
          npm = "@ai-sdk/openai";
          options = {
            baseURL = "https://api.mesa.rdlab.frec.myteambull.com/v1";
            apiKey = "{env:BSQ_API_KEY}";
          };
          models = {
            "qwen-3-8-flash-next" = {
              name = "qwen-3-8-flash-next";
              modalities = {
                input = [ "text" "image" ];
                output = [ "text" ];
              };
              variants = {
                none = {
                  reasoningEffort = "none";
                };
                low = {
                  reasoningEffort = "low";
                };
                medium = {
                  reasoningEffort = "medium";
                };
                xhigh = {
                  reasoningEffort = "xhigh";
                };
              };
            };
          };
        };
      };
    };
  };
}
