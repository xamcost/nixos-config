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
    ];
  };
}
