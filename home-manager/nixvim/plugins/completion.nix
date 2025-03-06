{
  programs.nixvim = {
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
	# snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

	mapping = {
	  "<C-d>" = "cmp.mapping.scroll_docs(-4)";
	  "<C-f>" = "cmp.mapping.scroll_docs(4)";
	  "<C-Space>" = "cmp.mapping.complete()";
	  "<C-e>" = "cmp.mapping.close()";
	  "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
	  "<CR>" = "cmp.mapping.confirm({ select = true })";
	};

	sources = [
	  { name = "path"; }
	  { name = "nvim_lsp"; }
	  # { name = "luasnip"; }
	  {
	    name = "buffer";
	    # Words from other open buffers can also be suggested.
	    option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
	  }
	  { name = "emoji"; }
	];
	settings = {
	  # Preselect first entry
	  completion.completeopt = "menu,menuone,noinsert";
	  sources = [
	    {
	      name = "nvim_lsp";
	      priority = 100;
	    }
	    {
	      name = "nvim_lsp_signature_help";
	      priority = 100;
	    }
	    {
	      name = "nvim_lsp_document_symbol";
	      priority = 100;
	    }
	    {
	      name = "treesitter";
	      priority = 80;
	    }
	    # {
	    #   name = "luasnip";
	    #   priority = 70;
	    # }
	    {
	      name = "copilot";
	      priority = 60;
	    }
	    {
	      name = "buffer";
	      priority = 50;
	      # Words from other open buffers can also be suggested.
	      option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
	      keywordLength = 3;
	    }
	    {
	      name = "path";
	      priority = 30;
	    }
	    {
	      name = "git";
	      priority = 20;
	    }
	    {
	      name = "npm";
	      priority = 20;
	    }
	    {
	      name = "zsh";
	      priority = 20;
	    }
	    # {
	    #   name = "calc";
	    #   priority = 10;
	    # }
	    {
	      name = "emoji";
	      priority = 5;
	    }
	  ];
	};
      };
    };

    plugins.lspkind = {
      enable = true;

      cmp.menu = {
	nvim_lsp = "";
	nvim_lua = "";
	buffer = "";
	calc = "";
	git = "";
	luasnip = "󰩫";
	codeium = "󱜙";
	copilot = "";
	emoji = "󰞅";
	path = "";
	spell = "";
      };

      symbolMap = {
	Namespace = "󰌗";
	Text = "󰊄";
	Method = "󰆧";
	Function = "󰡱";
	Constructor = "";
	Field = "󰜢";
	Variable = "󰀫";
	Class = "󰠱";
	Interface = "";
	Module = "󰕳";
	Property = "";
	Unit = "󰑭";
	Value = "󰎠";
	Enum = "";
	Keyword = "󰌋";
	Snippet = "";
	Color = "󰏘";
	File = "󰈚";
	Reference = "󰈇";
	Folder = "󰉋";
	EnumMember = "";
	Constant = "󰏿";
	Struct = "󰙅";
	Event = "";
	Operator = "󰆕";
	TypeParameter = "";
	Table = "";
	Object = "󰅩";
	Tag = "";
	Array = "[]";
	Boolean = "";
	Number = "";
	Null = "󰟢";
	String = "󰉿";
	Calendar = "";
	Watch = "󰥔";
	Package = "";
	Copilot = "";
	Codeium = "";
	TabNine = "";
      };

      extraOptions = {
	maxwidth = 50;
	ellipsis_char = "...";
      };
    };

    plugins.friendly-snippets.enable = true;
  };
}
