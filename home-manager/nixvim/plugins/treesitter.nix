{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;

      settings = {
        highlight = {
          enable = true;

          # Disable for large files and unnecessary filetypes
          disable = ''
            function(lang, bufnr)
              local line_count = vim.api.nvim_buf_line_count(bufnr)
              -- Disable for large files
              if line_count > 8000 then
                return true
              end

              -- Disable for help and man
              local ft = vim.bo[bufnr].filetype
              if ft == "help" or ft == "man" then
                return true
              end
              return false
            end
          '';

          # Reduce highlighting update frequency for performance
          additional_vim_regex_highlighting = false;
        };
        indent.enable = true;
        textobjects = {
          enable = true;
        };
      };

      folding = {
        enable = false;
      };
    };

    # To display current context on top of document
    plugins.treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        mode = "cursor";
        max_lines = 4;
      };
    };

    plugins.treesitter-textobjects = {
      enable = true;
      settings = {
        # Select text objects
        select = {
          enable = true;
          lookahead = true; # Automatically jump to next textobjects
          keymaps = {
            ak = {
              query = "@block.outer";
              desc = "around block";
            };
            ik = {
              query = "@block.inner";
              desc = "inside block";
            };
            ac = {
              query = "@class.outer";
              desc = "around class";
            };
            ic = {
              query = "@class.inner";
              desc = "inside class";
            };
            ai = {
              query = "@conditional.outer";
              desc = "around conditional";
            };
            ii = {
              query = "@conditional.inner";
              desc = "inside conditional";
            };
            af = {
              query = "@function.outer";
              desc = "around function";
            };
            "if" = {
              query = "@function.inner";
              desc = "inside function";
            };
            al = {
              query = "@loop.outer";
              desc = "around loop";
            };
            il = {
              query = "@loop.inner";
              desc = "inside loop";
            };
            aa = {
              query = "@parameter.outer";
              desc = "around argument";
            };
            ia = {
              query = "@parameter.inner";
              desc = "inside argument";
            };
            at = {
              query = "@comment.outer";
              desc = "around comment";
            };
            it = {
              query = "@comment.inner";
              desc = "inside comment";
            };
          };
        };
        # Jump across text objects
        move = {
          enable = true;
          set_jumps = true;

          goto_next_start = {
            "]k" = {
              query = "@block.outer";
              desc = "Next block start";
            };
            "]f" = {
              query = "@function.outer";
              desc = "Next function start";
            };
            "]c" = {
              query = "@class.outer";
              desc = "Next class start";
            };
            "]a" = {
              query = "@parameter.inner";
              desc = "Next argument start";
            };
          };

          goto_next_end = {
            "]K" = {
              query = "@block.outer";
              desc = "Next block end";
            };
            "]F" = {
              query = "@function.outer";
              desc = "Next function end";
            };
            "]C" = {
              query = "@class.outer";
              desc = "Next class end";
            };
            "]A" = {
              query = "@parameter.inner";
              desc = "Next argument end";
            };
          };

          goto_previous_start = {
            "[k" = {
              query = "@block.outer";
              desc = "Previous block start";
            };
            "[f" = {
              query = "@function.outer";
              desc = "Previous function start";
            };
            "[c" = {
              query = "@class.outer";
              desc = "Previous class start";
            };
            "[a" = {
              query = "@parameter.inner";
              desc = "Previous argument start";
            };
          };

          goto_previous_end = {
            "[K" = {
              query = "@block.outer";
              desc = "Previous block end";
            };
            "[F" = {
              query = "@function.outer";
              desc = "Previous function end";
            };
            "[C" = {
              query = "@class.outer";
              desc = "Previous class end";
            };
            "[A" = {
              query = "@parameter.inner";
              desc = "Previous argument end";
            };
          };
        };
        # Swap nodes with next/previous one
        swap = {
          enable = true;

          swap_next = {
            ">K" = {
              query = "@block.outer";
              desc = "Swap next block";
            };
            ">F" = {
              query = "@function.outer";
              desc = "Swap next function";
            };
            ">A" = {
              query = "@parameter.inner";
              desc = "Swap next argument";
            };
          };

          swap_previous = {
            "<K" = {
              query = "@block.outer";
              desc = "Swap previous block";
            };
            "<F" = {
              query = "@function.outer";
              desc = "Swap previous function";
            };
            "<A" = {
              query = "@parameter.inner";
              desc = "Swap previous argument";
            };
          };
        };
      };
    };
    plugins.ts-autotag.enable = true;
  };
}
