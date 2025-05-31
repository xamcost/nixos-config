{ pkgs, homeConfigName, ... }:
let
  imageEnabled =
    !builtins.elem homeConfigName [ "xam@aeneas" "xamcost@elysium" ];
  # Enables Github dashboard features for the specified home configuration
  enableGitHubDashboardFeatures = builtins.elem homeConfigName [
    "mcostalonga@xam-mac-work"
    "maximecostalonga@xam-mac-m4"
  ];

  commonPane2Section = {
    pane = 2;
    section = "terminal";
    enabled.__raw = "Snacks.git.get_root() ~= nil";
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

  dashboardSections = baseDashboardSections
    ++ (if enableGitHubDashboardFeatures then githubDashboardSections else [ ]);
in {
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        bigfile = { enabled = true; };

        gitbrowse = { enabled = true; };

        image = { enabled = imageEnabled; };

        indent = { enabled = true; };

        lazygit = { enabled = true; };

        quickfile = { enabled = true; };

        notifier = { enabled = true; };

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
      {
        mode = "n";
        key = "<leader>us";
        action.__raw = ''
          function()
            require('snacks').notifier.show_history()
          end
        '';
        options = {
          desc = "Show Notifications";
          silent = true;
        };
      }
      # Pickers
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = ''
          function()
            require('snacks').picker.smart()
          end
        '';
        options = {
          desc = "Find Files";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action.__raw = ''
          function()
            require('snacks').picker.recent()
          end
        '';
        options = {
          desc = "Recent Files";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = ''
          function()
            require('snacks').picker.grep()
          end
        '';
        options = {
          desc = "Live Grep";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fp";
        action.__raw = ''
          function()
            require('snacks').picker.projects()
          end
        '';
        options = {
          desc = "Find Projects";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>f:";
        action.__raw = ''
          function()
            require('snacks').picker.command_history()
          end
        '';
        options = {
          desc = "Command History";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>s?";
        action.__raw = ''
          function()
            require('snacks').picker.help()
          end
        '';
        options = {
          desc = "Help Pages";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sm";
        action.__raw = ''
          function()
            require('snacks').picker.man()
          end
        '';
        options = {
          desc = "Man Pages";
          silent = true;
        };
      }
      {
        mode = [ "n" "x" ];
        key = "<leader>sw";
        action.__raw = ''
          function()
            require('snacks').picker.grep_word()
          end
        '';
        options = {
          desc = "Word under Cursor";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action.__raw = ''
          function()
            require('snacks').picker.lines()
          end
        '';
        options = {
          desc = "Lines in Buffer";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sb";
        action.__raw = ''
          function()
            require('snacks').picker.buffers()
          end
        '';
        options = {
          desc = "Buffers";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ss";
        action.__raw = ''
          function()
            require('snacks').picker.lsp_symbols()
          end
        '';
        options = {
          desc = "LSP Symbols";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sS";
        action.__raw = ''
          function()
            require('snacks').picker.lsp_workspace_symbols()
          end
        '';
        options = {
          desc = "LSP Workspace Symbols";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sk";
        action.__raw = ''
          function()
            require('snacks').picker.keymaps()
          end
        '';
        options = {
          desc = "Keymaps";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>s:";
        action.__raw = ''
          function()
            require('snacks').picker.commands()
          end
        '';
        options = {
          desc = "Commands";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-p>";
        action.__raw = ''
          function()
            require('snacks').picker.registers()
          end
        '';
        options = {
          desc = "Registers";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gc";
        action.__raw = ''
          function()
            require('snacks').picker.git_log()
          end
        '';
        options = {
          desc = "Search Log";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gC";
        action.__raw = ''
          function()
            require('snacks').picker.git_log_line()
          end
        '';
        options = {
          desc = "Search Log Line";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action.__raw = ''
          function()
            require('snacks').picker.git_log_file()
          end
        '';
        options = {
          desc = "Search Log File";
          silent = true;
        };
      }
    ];

    plugins.which-key.settings.spec = [{
      __unkeyed-1 = "<leader>g";
      mode = "n";
      icon = " ";
      group = "Git";
    }];
  };
}
