{
  pkgs,
  inputs,
  homeConfigName,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./keymaps.nix
    ./plugins
  ];

  home.shellAliases.v = "nvim";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    extraPackages = with pkgs; [
      ripgrep # For Live Grep in Snacks picker
      black
      isort
      jq
      nixfmt
      nixpkgs-fmt
      prettierd
      rust-analyzer
      rustfmt
      shfmt
      stylua
    ];

    extraPlugins = [
      pkgs.vimPlugins.img-clip-nvim
    ];

    extraConfigLua = ''
      -- Configures img-clip for Avante and Obsidian
      require('img-clip').setup({
        default = {
          dir_path = "_resources",
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          relative_template_path = function()
            local working_dir = vim.fn.getcwd()
            if (working_dir:find("Obsidian/asphodel")) then
              return false
            end
            return true
          end,
        },
      })
    '';

    globals = {
      mapleader = " ";
      maplocalleader = ",";
      opencode_opts = {
        provider = {
          enabled = "tmux";
          tmux = {
            options = "-h -p 40";
          };
        };
      };
    };

    colorschemes.tokyonight.enable = true;

    plugins = {
      lz-n.enable = true; # For Lazy loading
      web-devicons.enable = true;
    };

    opts = {
      clipboard = "unnamedplus";
      #undofile = true;
      number = true;
      relativenumber = true;
      conceallevel = 1;
      # indentation
      autoindent = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };
  };
}
