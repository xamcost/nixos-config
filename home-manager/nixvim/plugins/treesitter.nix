{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      folding = false;
    };

    plugins.treesitter-context = {
      enable = true;
      settings = {
	mode = "cursor";
	max_lines = 3;
      };
    };
  };
}
