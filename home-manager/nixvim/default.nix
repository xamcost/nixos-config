{
  pkgs,
  inputs,
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
      jq
      nixfmt
      nixpkgs-fmt
      prettierd
      ruff
      rumdl
      rust-analyzer
      rustfmt
      shfmt
      stylua
    ];

    extraPlugins = [
      pkgs.vimPlugins.stay-centered-nvim
      # (pkgs.vimUtils.buildVimPlugin {
      #   name = "atlas";
      #   doCheck = false;
      #   # src = pkgs.fetchFromGitHub {
      #   #   owner = "emrearmagan";
      #   #   repo = "atlas.nvim";
      #   #   rev = "353d5683c8c4602718b6a9f27d75205ebc06cfd0";
      #   #   hash = "sha256-EqNGwea0ULLguW+zfKDkY+SCGvCEZkqDaKNxr38WGSE=";
      #   # };
      #   src = builtins.fetchGit {
      #     url = "/Users/maximecostalonga/Documents/personal/code/atlas.nvim";
      #     rev = "f4d4297eec75d0d203282e772bd165b443519454";
      #   };
      # })
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

      --   vim.opt.rtp:append("~/Documents/personal/code/atlas.nvim")
      --
      --   require("atlas").setup({
      --     pulls = {
      --       providers = {
      --         bitbucket = {
      --           url = os.getenv("BITBUCKET_URL") or "";
      --           user = os.getenv("BITBUCKET_USER") or "";
      --           token = os.getenv("BITBUCKET_TOKEN") or "";
      --         },
      --         github = { },
      --       },
      --     },
      --     issues = {
      --       providers = {
      --         jira = {
      --           base_url = os.getenv("JIRA_URL") or "";
      --           email = os.getenv("WORK_EMAIL") or "";
      --           token = os.getenv("JIRA_TOKEN") or "";
      --           api_type = "server";
      --           auth_method = "bearer";
      --         },
      --         github = { },
      --       },
      --     },
      --     keymaps = {
      --       issues = {
      --         transition_issue = "gb";
      --       },
      --     },
      --   })
      -- '';

    globals = {
      mapleader = " ";
      maplocalleader = ",";
      opencode_opts = {
        server = {
          start.__raw = ''
            function()
              local cmd = "tmux splitw -h -p 40 -- opencode --port"
              vim.fn.jobstart(cmd, { detach = true })
            end
          '';
          stop.__raw = ''
            function()
              local cmd = "tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep 'opencode' | awk '{print $1}' | xargs -I {} tmux kill-pane -t {}"
              vim.fn.jobstart(cmd, { detach = true })
            end
          '';
          toggle.__raw = ''
            function()
              local cmd = "tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep -q 'opencode' && tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep 'opencode' | (awk '{print $1}' | xargs -I {} tmux kill-pane -t {}) || tmux splitw -h -p 40 -- opencode --port"
              vim.fn.jobstart(cmd, { detach = true })
            end
          '';
          # enabled = "tmux";
          # tmux = {
          #   options = "-h -p 40";
          # };
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
