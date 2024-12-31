{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
          };
          options = {
            customCommentString = ''
              <cmd>lua require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring<cr>
            '';
          };
        };
        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
          };
        };
	pairs = {};
	surround = {};
      };
    };
  };
}
