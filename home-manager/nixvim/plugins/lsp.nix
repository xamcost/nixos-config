{ lib, homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [
    "xam@aeneas"
  ];
  machine = builtins.elemAt (lib.splitString "@" homeConfigName) 1;
  configType = if builtins.elem homeConfigName [ "mcostalonga@xam-mac-work" ] then "darwinConfigurations" else "nixosConfigurations";
in
{
  programs.nixvim = {
    plugins.lsp = {
      enable = isEnabled;
      servers = {
        astro = {
          enable = true;
        };
        helm_ls = {
          enable = true;
          filetypes = [ "helm" ];
        };
        # Python
        jedi_language_server = {
          enable = true;
        };
        # Markdown
        marksman = {
          enable = true;
        };
        # Nix
        nixd = {
          enable = true;
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
        };
      };
    };

    keymaps = if isEnabled then [
      {
        mode = "n";
        key = "<leader>ll";
        action = {
          __raw = ''
            function()
              if vim.g.diagnostics_visible then
          vim.g.diagnostics_visible = false
          vim.diagnostic.disable()
              else
          vim.g.diagnostics_visible = true
          vim.diagnostic.enable()
              end
            end
          '';
        };
        options = {desc = "Toggle diagnostics";};
      }
    ] else [];
  };
}

