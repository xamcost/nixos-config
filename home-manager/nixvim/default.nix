{ pkgs, inputs, ... }: {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ./keymaps.nix ./plugins ];

  home.shellAliases.v = "nvim";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep # For Telescope
      black
      isort
      jq
      nixfmt
      nixpkgs-fmt
      nodePackages.prettier
      prettierd
      rust-analyzer
      rustfmt
      shfmt
      stylua
    ];

    globals.mapleader = " ";

    colorschemes.tokyonight.enable = true;

    # Dependencies for many plugins such as Telescope, bufferline, etc.
    plugins.web-devicons.enable = true;

    plugins.which-key.enable = true;

    opts = {
      clipboard = "unnamedplus";
      #undofile = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
  };
}
