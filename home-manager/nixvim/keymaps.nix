{
  programs.nixvim.keymaps = [
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
}
