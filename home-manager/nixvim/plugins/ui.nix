{
  programs.nixvim = {
    plugins.notify = {
      enable = true;
      settings = {
        stages = "static"; # remove animations for performance
        timeout = 4000;
      };
    };

    plugins.noice = {
      enable = true;
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          progress.enabled = true;
        };

        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = true;
        };
        notify.enabled = true;
      };
    };

    plugins.nui = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>un";
        action = ''
          <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
        '';
        options = {
          desc = "Dismiss All Notifications";
        };
      }
    ];
  };
}
