{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.username = "xamcost";
  home.homeDirectory = "/home/xamcost";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/xamcost/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 50000;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
    };
  };

  # Nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    colorschemes.tokyonight.enable = true;

    plugins.bufferline.enable = true;
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find files";
          };
        };
        "<leader>fw" = {
          action = "live_grep";
          options = {
            desc = "Live grep";
          };
        };
      };
    };
    plugins.neo-tree.enable = true;
    plugins.which-key.enable = true;

    opts = {
      #clipboard = "unnamedplus";
      #undofile = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Space>";
        action = "<Nop>";
        options = {silent = true; noremap = true;};
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options = {desc = "Prev buffer"; remap = true;};
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options = {desc = "Next buffer"; remap = true;};
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {desc = "Go to Left Window"; remap = true;};
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {desc = "Go to Lower Window"; remap = true;};
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {desc = "Go to Upper Window"; remap = true;};
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {desc = "Go to Right Window"; remap = true;};
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options = {desc = "Increase Window Height";};
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options = {desc = "Decrease Window Height";};
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options = {desc = "Decrease Window Width";};
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options = {desc = "Increase Window Width";};
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree action=focus reveal toggle<CR>";
        options = {desc = "Toggle Neotree";};
      }
    ];

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
