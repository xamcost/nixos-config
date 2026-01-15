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
      pkgs.vimPlugins.stay-centered-nvim
    ];

    extraConfigLua = ''
      require('stay-centered').setup({
        -- The filetype is determined by the vim filetype, not the file extension. In order to get the filetype, open a file and run the command:
        -- :lua print(vim.bo.filetype)
        skip_filetypes = {},
        -- Set to false to disable by default
        enabled = true,
        -- allows scrolling to move the cursor without centering, default recommended
        allow_scroll_move = true,
        -- temporarily disables plugin on left-mouse down, allows natural mouse selection
        -- try disabling if plugin causes lag, function uses vim.on_key
        disable_on_mouse = true,
      })
      vim.keymap.set({ 'n', 'v' }, '<leader>uc', require('stay-centered').toggle, { desc = 'Toggle stay-centered.nvim' })
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
