{ pkgs, homeConfigName, ... }:
  let
    # Enables Github dashboard features for the specified home configuration
    enableGitHubDashboardFeatures = builtins.elem homeConfigName [ "mcostalonga@xam-mac-work" ];

    commonPane2Section = {
      pane = 2;
      section = "terminal";
      enabled.__raw = ''Snacks.git.get_root() ~= nil'';
      padding = 1;
      ttl = 5 * 60;
      indent = 3;
    };
    
    # Base dashboard sections that are always included
    baseDashboardSections = [
      {
        section = "header";
        padding = 1;
      }
      {
        icon = " ";
        title = "Keymaps";
        section = "keys";
        gap = 1;
        padding = 1;
        indent = 3;
      }
      {
        icon = " ";
        title = "Recent Files";
        section = "recent_files";
        padding = 1;
        indent = 3;
      }
      {
        icon = " ";
        title = "Projects";
        section = "projects";
        padding = 1;
        indent = 3;
      }
      (commonPane2Section // {
        icon = " ";
        title = "Git Status";
        cmd = "${pkgs.hub}/bin/hub status --short --branch --renames";
        height = 5;
      })
    ];
    
    # GitHub-specific sections that are conditionally included
    githubDashboardSections = [
      (commonPane2Section // {
        icon = " ";
        title = "Notifications";
        cmd = "gh notify -s -a -n5";
        height = 5;
      })
      (commonPane2Section // {
        icon = " ";
        title = "Open PRs";
        cmd = "gh pr list -L 3";
        height = 7;
      })
      (commonPane2Section // {
        icon = " ";
        title = "Open Issues";
        cmd = "gh issue list -L 3";
        height = 7;
      })
    ];

    dashboardSections = baseDashboardSections ++ (if enableGitHubDashboardFeatures then githubDashboardSections else []);
  in
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

	dashboard = {
	  enabled = true;
	  preset = {
	    keys = [
	      {
		icon = " ";
		key = "f";
		desc = "Find File";
		action = "<leader>ff";
	      }
	      {
		icon = " ";
		key = "n";
		desc = "New File";
		action = ":ene | startinsert";
	      }
	      {
		icon = " ";
		key = "w";
		desc = "Find Text";
		action = "<leader>fw";
	      }
	      {
		icon = " ";
		key = "r";
		desc = "Recent Files";
		action = "<leader>fr";
	      }
	      {
		icon = " ";
		key = "s";
		desc = "Restore Session";
		action = "<leader>Ss";
	      }
	      {
		icon = "";
		key = "g";
		desc = "LazyGit";
		action = "<leader>gg";
	      }
	      {
		icon = " ";
		key = "b";
		desc = "Browse Repo";
		action = "<leader>gB";
	      }
	      {
		icon = " ";
		key = "q";
		desc = "Quit";
		action = ":qa";
	      }
	    ];
	  };
	  sections = dashboardSections;
	  # sections = [
	  #   {
	  #     section = "header";
	  #     padding = 1;
	  #   }
	  #   {
	  #     icon = " ";
	  #     title = "Keymaps";
	  #     section = "keys";
	  #     gap = 1;
	  #     padding = 1;
	  #     indent = 3;
	  #   }
	  #   {
	  #     icon = " ";
	  #     title = "Recent Files";
	  #     section = "recent_files";
	  #     padding = 1;
	  #     indent = 3;
	  #   }
	  #   {
	  #     icon = " ";
	  #     title = "Projects";
	  #     section = "projects";
	  #     padding = 1;
	  #     indent = 3;
	  #   }
	  #   (commonPane2Section // {
	  #     icon = " ";
	  #     title = "Git Status";
	  #     cmd = "${pkgs.hub}/bin/hub status --short --branch --renames";
	  #     height = 5;
	  #   })
	  #   (commonPane2Section // {
	  #     icon = " ";
	  #     title = "Notifications";
	  #     cmd = "gh notify -s -a -n5";
	  #     height = 5;
	  #   })
	  #   (commonPane2Section // {
	  #     icon = " ";
	  #     title = "Open PRs";
	  #     cmd = "gh pr list -L 3";
	  #     height = 7;
	  #   })
	  #   (commonPane2Section // {
	  #     icon = " ";
	  #     title = "Open Issues";
	  #     cmd = "gh issue list -L 3";
	  #     height = 7;
	  #   })
	  # ];
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
