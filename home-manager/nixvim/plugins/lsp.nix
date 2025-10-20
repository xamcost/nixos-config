{ lib, homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [ "xam@aeneas" ];
  machine = builtins.elemAt (lib.splitString "@" homeConfigName) 1;
  configType =
    if
      builtins.elem homeConfigName [
        "mcostalonga@xam-mac-work"
        "maximecostalonga@xam-mac-m4"
      ]
    then
      "darwinConfigurations"
    else
      "nixosConfigurations";
in
{
  programs.nixvim = {
    plugins.lsp = {
      enable = isEnabled;
      servers = {
        astro = {
          enable = true;
          filetypes = [ "astro" ];
        };
        bashls = {
          enable = true;
          filetypes = [
            "sh"
            "bash"
          ];
        };
        dockerls = {
          enable = true;
          filetypes = [ "dockerfile" ];
        };
        helm_ls = {
          enable = true;
          filetypes = [ "helm" ];
        };
        jsonls = {
          enable = true;
          filetypes = [ "json" ];
          settings = {
            json = {
              schemas = [
                {
                  fileMatch = [ "package.json" ];
                  url = "https://json.schemastore.org/package.json";
                }
                {
                  fileMatch = [
                    "tsconfig.json"
                    "tsconfig.*.json"
                  ];
                  url = "https://json.schemastore.org/tsconfig.json";
                }
                {
                  fileMatch = [ ".eslintrc.json" ];
                  url = "https://json.schemastore.org/eslintrc.json";
                }
                {
                  fileMatch = [ ".prettierrc.json" ];
                  url = "https://json.schemastore.org/prettierrc.json";
                }
              ];
            };
          };
        };
        # Python
        pylsp = {
          enable = true;
          filetypes = [ "python" ];
          settings = {
            plugins = {
              flake8 = {
                enabled = true;
                maxLineLength = 88;
              };
              autopep8 = {
                enabled = true;
              };
              pycodestyle = {
                enabled = true;
                ignore = [ "E501" ];
              };
              black = {
                enabled = true;
                line_length = 88;
              };
              isort = {
                enabled = true;
                profile = "black";
              };
            };
          };
        };
        # Markdown
        marksman = {
          enable = true;
          filetypes = [ "markdown" ];
        };
        # Nix
        nixd = {
          enable = true;
          filetypes = [ "nix" ];
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
            nixpkgs = {
              expr = "import <nixpkgs> {}";
            };
            options = {
              nixos.expr = ''(builtins.getFlake ("github:xamcost/nixos-config")).${configType}.${machine}.options'';
              home-manager.expr = ''(builtins.getFlake ("github:xamcost/nixos-config")).homeManagerConfigurations."${homeConfigName}".options'';
            };
          };
        };
        rust_analyzer = {
          enable = true;
          filetypes = [ "rust" ];
          installCargo = true;
          installRustc = true;
        };
        tailwindcss = {
          enable = true;
        };
        terraformls = {
          enable = true;
        };
        # Typescript
        ts_ls = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
        };
        yamlls = {
          enable = true;
          filetypes = [ "yaml" ];
        };
      };
      keymaps = {
        diagnostic = {
          "<leader>ld" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
          "<leader>lq" = {
            action = "setloclist";
            desc = "List Diagnostics";
          };
        };
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Goto Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>lr" = {
            action = "rename";
            desc = "Rename references";
          };
          "<leader>lf" = {
            action = "format";
            desc = "Format buffer";
          };
        };
        extra = [
          {
            action.__raw = ''
              function()
                vim.lsp.buf.format({
                  async = true,
                  range = {
                    ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                    ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                  }
                })
              end
            '';
            mode = "v";
            key = "<leader>lf";
            options = {
              desc = "Format selection";
            };
          }
        ];
      };
    };

    plugins.lsp-lines.enable = isEnabled;

    plugins.which-key.settings.spec = lib.mkIf isEnabled [
      {
        __unkeyed-1 = "<leader>l";
        mode = "n";
        icon = " ";
        group = "LSP";
      }
    ];

    keymaps =
      if isEnabled then
        [
          {
            mode = "n";
            key = "<leader>ll";
            action = {
              __raw = ''
                -- function()
                --   if vim.g.diagnostics_visible then
                --     vim.g.diagnostics_visible = false
                --     vim.diagnostic.disable()
                --   else
                --     vim.g.diagnostics_visible = true
                --     vim.diagnostic.enable()
                --   end
                -- end
                require("lsp_lines").toggle
              '';
            };
            options = {
              desc = "Toggle diagnostics";
            };
          }
        ]
      else
        [ ];
  };
}
