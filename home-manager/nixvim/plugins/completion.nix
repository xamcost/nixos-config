{ lib, ... }:
{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;
      settings = {
        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window = {
              border = "rounded";
            };
          };
        };

        keymap = {
          preset = "super-tab";
          "<C-j>" = [
            "show"
            "show_documentation"
            "hide_documentation"
            "fallback"
          ];
          # "<S-Tab>" = [
          #   "snippet_backward"
          #   "fallback"
          # ];
          # "<C-e>" = [
          #   "hide"
          #   "fallback"
          # ];
          # "<Up>" = [
          #   "select_prev"
          #   "fallback"
          # ];
          # "<Down>" = [
          #   "select_next"
          #   "fallback"
          # ];
          # "<C-p>" = [
          #   "select_prev"
          #   "fallback_to_mappings"
          # ];
          # "<C-n>" = [
          #   "select_next"
          #   "fallback_to_mappings"
          # ];
          "<C-d>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          # "<C-k>" = [
          #   "show_signature"
          #   "hide_signature"
          #   "fallback"
          # ];
        };

        sources = {
          default.__raw = ''
            function(ctx)
              local defaults = { 'lsp', 'path', 'snippets', 'buffer' }
              if vim.bo.filetype == 'markdown' then
                return { 'emoji', 'buffer', 'path' }
              else
                return defaults
              end
            end
          '';

          providers = {
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = 15;
              opts = {
                insert = true; # Insert emoji (default) or complete its name
                trigger.__raw = ''
                  ---@type string|table|fun():table
                  function()
                    return { ":" }
                  end
                '';
              };
            };
          };
        };

        appearance = {
          kind_icons = {
            # Default icons
            Text = "󰉿";
            Method = "󰊕";
            Function = "󰊕";
            Constructor = "󰒓";

            Field = "󰜢";
            Variable = "󰆦";
            Property = "󰖷";

            Class = "󱡠";
            Interface = "󱡠";
            Struct = "󱡠";
            Module = "󰅩";

            Unit = "󰪚";
            Value = "󰦨";
            Enum = "󰦨";
            EnumMember = "󰦨";

            Keyword = "󰻾";
            Constant = "󰏿";

            Snippet = "󱄽";
            Color = "󰏘";
            File = "󰈔";
            Reference = "󰬲";
            Folder = "󰉋";
            Event = "󱐋";
            Operator = "󰪚";
            TypeParameter = "󰬛";

            # Custom icons
            Emoji = "󰞅";
          };
        };
      };
    };

    plugins.blink-emoji = {
      enable = true;
    };

    plugins.blink-cmp-dictionary = {
      enable = true;
      autoLoad = true;
    };

    plugins.cmp = {
      enable = false;
      autoEnableSources = true;

      settings = {
        # snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };

        sources = [
          { name = "path"; }
          { name = "nvim_lsp"; }
          # { name = "luasnip"; }
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
          { name = "emoji"; }
        ];
        settings = {
          # Preselect first entry
          completion.completeopt = "menu,menuone,noinsert";
          sources = [
            {
              name = "nvim_lsp";
              priority = 100;
            }
            {
              name = "nvim_lsp_signature_help";
              priority = 100;
            }
            {
              name = "nvim_lsp_document_symbol";
              priority = 100;
            }
            {
              name = "treesitter";
              priority = 80;
            }
            # {
            #   name = "luasnip";
            #   priority = 70;
            # }
            {
              name = "copilot";
              priority = 60;
            }
            {
              name = "buffer";
              priority = 50;
              # Words from other open buffers can also be suggested.
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            {
              name = "path";
              priority = 30;
            }
            {
              name = "git";
              priority = 20;
            }
            {
              name = "npm";
              priority = 20;
            }
            {
              name = "zsh";
              priority = 20;
            }
            # {
            #   name = "calc";
            #   priority = 10;
            # }
            {
              name = "emoji";
              priority = 5;
            }
          ];
        };
      };
    };

    plugins.lspkind = {
      enable = true;

      settings = {
        cmp.menu = {
          nvim_lsp = "";
          nvim_lua = "";
          buffer = "";
          calc = "";
          git = "";
          luasnip = "󰩫";
          codeium = "󱜙";
          copilot = "";
          emoji = "󰞅";
          path = "";
          spell = "";
        };

        symbolMap = {
          Namespace = "󰌗";
          Text = "󰊄";
          Method = "󰆧";
          Function = "󰡱";
          Constructor = "";
          Field = "󰜢";
          Variable = "󰀫";
          Class = "󰠱";
          Interface = "";
          Module = "󰕳";
          Property = "";
          Unit = "󰑭";
          Value = "󰎠";
          Enum = "";
          Keyword = "󰌋";
          Snippet = "";
          Color = "󰏘";
          File = "󰈚";
          Reference = "󰈇";
          Folder = "󰉋";
          EnumMember = "";
          Constant = "󰏿";
          Struct = "󰙅";
          Event = "";
          Operator = "󰆕";
          TypeParameter = "";
          Table = "";
          Object = "󰅩";
          Tag = "";
          Array = "[]";
          Boolean = "";
          Number = "";
          Null = "󰟢";
          String = "󰉿";
          Calendar = "";
          Watch = "󰥔";
          Package = "";
          Copilot = "";
          Codeium = "";
          TabNine = "";
        };

        extraOptions = {
          maxwidth = 50;
          ellipsis_char = "...";
        };
      };
    };

    plugins.friendly-snippets.enable = true;
  };
}
