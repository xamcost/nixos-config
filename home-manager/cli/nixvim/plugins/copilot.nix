{
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;
      panel = { enabled = false; };
      suggestion = {
        enabled = true;
        autoTrigger = true;
        keymap = {
          accept = "<C-l>";
          acceptWord = false;
          acceptLine = false;
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<M-Bslash>";
          # next = "<C-.>";
          # prev = "<C-,>";
          # dismiss = "<C/>";
        };
      };
      filetypes = {
        markdown = true;
        yaml = true;
      };
    };
  };
}

