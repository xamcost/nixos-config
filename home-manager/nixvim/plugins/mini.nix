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

	pairs = {};

	surround = {
	  mappings = {
	    add = "gsa";
	    delete = "gsd";
	    find = "gsf";
	    find_left = "gsF";
	    highlight = "gsh";
	    replace = "gsr";
	    update_n_lines = "gsn";
	  };
	};
      };
    };
  };
}
