{ homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" ];
in
{
  programs.nixvim = {
    plugins.opencode = {
      enable = isEnabled;
    };

    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>ca";
        action = {
          __raw = ''function() require("opencode").ask("@this: ", { submit = true }) end'';
        };
        options = {
          desc = "Ask about this";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cs";
        action = {
          __raw = ''function() require("opencode").select() end'';
        };
        options = {
          desc = "Select prompt";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cp";
        action = {
          __raw = ''function() require("opencode").prompt("@this") end'';
        };
        options = {
          desc = "Add this to prompt";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>ce";
        action = {
          __raw = ''
            function()
              local explain = require("opencode.config").opts.prompts.explain
              require("opencode").prompt(explain.prompt, explain)
            end
          '';
        };
        options = {
          desc = "Explain";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cd";
        action = {
          __raw = ''
            function()
              local document = require("opencode.config").opts.prompts.document
              require("opencode").prompt(document.prompt, document)
            end
          '';
        };
        options = {
          desc = "Document";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>co";
        action = {
          __raw = ''
            function()
              local optimize = require("opencode.config").opts.prompts.optimize
              require("opencode").prompt(optimize.prompt, optimize)
            end
          '';
        };
        options = {
          desc = "Optimize";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cT";
        action = {
          __raw = ''
            function()
              local test = require("opencode.config").opts.prompts.test
              require("opencode").prompt(test.prompt, test)
            end
          '';
        };
        options = {
          desc = "Add tests";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cr";
        action = {
          __raw = ''
            function()
              local review = require("opencode.config").opts.prompts.review
              require("opencode").prompt(review.prompt, review)
            end
          '';
        };
        options = {
          desc = "Review";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cf";
        action = {
          __raw = ''
            function()
              local fix = require("opencode.config").opts.prompts.fix
              require("opencode").prompt(fix.prompt, fix)
            end
          '';
        };
        options = {
          desc = "Fix diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>ct";
        action = {
          __raw = ''function() require("opencode").toggle() end'';
        };
        options = {
          desc = "Toggle embedded";
        };
      }
      {
        mode = "n";
        key = "<leader>cc";
        action = {
          __raw = ''function() require("opencode").command() end'';
        };
        options = {
          desc = "Select command";
        };
      }
      {
        mode = "n";
        key = "<leader>cn";
        action = {
          __raw = ''function() require("opencode").command("session_new") end'';
        };
        options = {
          desc = "New session";
        };
      }
      {
        mode = "n";
        key = "<leader>ci";
        action = {
          __raw = ''function() require("opencode").command("session_interrupt") end'';
        };
        options = {
          desc = "Interrupt session";
        };
      }
      {
        mode = "n";
        key = "<leader>cv";
        action = {
          __raw = ''function() require("opencode").command("agent_cycle") end'';
        };
        options = {
          desc = "Cycle agent";
        };
      }
      {
        mode = "n";
        key = "S-C-u";
        action = {
          __raw = ''function() require("opencode").command("messages_half_page_up") end'';
        };
        options = {
          desc = "Messages half page up";
        };
      }
      {
        mode = "n";
        key = "S-C-d";
        action = {
          __raw = ''function() require("opencode").command("messages_half_page_down") end'';
        };
        options = {
          desc = "Messages half page down";
        };
      }
    ];
  };
}
