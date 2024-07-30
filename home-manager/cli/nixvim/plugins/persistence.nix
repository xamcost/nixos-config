{
  programs.nixvim = {
    plugins.persistence = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>Ss";
        action = {
	  __raw = ''function() require("persistence").load() end'';
	};
        options = {desc = "Restore Session";};
      }
      {
        mode = "n";
        key = "<leader>Sl";
        action = {
	  __raw = ''function() require("persistence").load({ last = true }) end'';
	};
        options = {desc = "Restore Last Session";};
      }
      {
        mode = "n";
        key = "<leader>Sd";
        action = {
          __raw = ''function() require("persistence").stop() end'';
        };
        options = {desc = "Stop Session";};
      }
    ];
  };
}
