{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
	bigfile = {
	  enabled = true;
	};

	gitbrowse = {
	  enabled = true;
	};

	lazygit = {
	  enabled = true;
        };
      };
    };

    keymaps = [
      {
	mode = "n";
	key = "<leader>gB";
	action.__raw = ''
	  function()
	    require('snacks').gitbrowse()
	  end
	'';
	options.desc = "Browse Repo";
      }
      {
	mode = "n";
	key = "<leader>gg";
	action.__raw = ''
	  function()
	    require('snacks').lazygit()
	  end
	'';
	options.desc = "Lazygit";
      }
    ];

    plugins.which-key.settings.spec = [
      {
	__unkeyed-1 = "<leader>g";
	mode = "n";
	icon = " ";
	group = "Git";
      }
    ];
  };
}
