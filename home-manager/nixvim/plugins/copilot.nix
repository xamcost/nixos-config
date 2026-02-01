{ homeConfigName, ... }:
let
  isEnabled =
    !builtins.elem homeConfigName [
      "xam@aeneas"
    ];
in
{
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = isEnabled;
      settings = {
        panel = {
          enabled = false;
        };
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<C-l>";
            acceptWord = false;
            acceptLine = false;
            next = "<M-.>";
            prev = "<M-,>";
            dismiss = "<M-/>";
            # next = "<C-.>";
            # prev = "<C-,>";
            # dismiss = "<C/>";
          };
        };
        filetypes = {
          # markdown = true;
          markdown.__raw = ''
            function()
              -- disable for obsidian vault files
              if string.match(vim.api.nvim_buf_get_name(0), '.*/Obsidian/.*') then
                return false
              end
              return true
            end
          '';
          yaml = true;
          sh.__raw = ''
            function()
              if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                -- disable for .env files
                return false
              end
              return true
            end
          '';
        };
      };
    };
  };
}
