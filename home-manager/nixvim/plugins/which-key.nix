{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "helix";
        spec = [
          {
            __unkeyed-1 = "<leader>g";
            mode = "n";
            icon = " ";
            group = "Git";
          }
        ];
      };
    };
  };
}
