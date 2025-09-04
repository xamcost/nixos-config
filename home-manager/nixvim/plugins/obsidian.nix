{ homeConfigName, ... }:
let
  isEnabled =
    !builtins.elem homeConfigName [
      "xam@aeneas"
      "xamcost@elysium"
    ];
in
{
  programs.nixvim = {
    plugins.telescope.enable = isEnabled;

    plugins.obsidian = {
      enable = isEnabled;

      luaConfig.post = ''
        vim.api.nvim_create_user_command("ON", function()
          vim.cmd("Obsidian new")
          vim.cmd("normal! gg") -- go to beginning of the file
          vim.cmd("normal! 5dd") -- delete the first 5 lines (frontmatter)
          vim.cmd("Obsidian template")
          vim.cmd("normal! dG") -- delete the duplicated title
        end, {})

        vim.api.nvim_create_autocmd("User", {
          pattern = "ObsidianNoteEnter",
          callback = function(ev)
            vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", {
              buffer = ev.buf,
              desc = "Toggle checkbox",
            })
          end,
        })
      '';

      lazyLoad = {
        settings = {
          ft = "markdown";
        };
      };

      settings = {
        workspaces = [
          {
            name = "asphodel";
            path = "~/Documents/Obsidian/asphodel";
          }
        ];

        templates = {
          folder = "Templates";
          date_format = "%Y-%m-%d";
          time_format = "%H:%M";
        };

        disable_frontmatter = false;

        new_notes_location = "current_dir";
        preferred_link_style = "markdown";

        attachments = {
          img_folder = "_resources";
        };

        note_path_func.__raw = ''
          ---@param spec { id: string, dir: obsidian.Path, title: string|? }
          ---@return string|obsidian.Path The full path to the new note.
          function(spec)
            -- Original behaviour: local path = spec.dir / toString(spec.id)
            local path = spec.dir / tostring(spec.title)
            return path:with_suffix(".md")
          end
        '';

        daily_notes = {
          folder = "Journal";
          date_format = "%Y-%m-%d";
          default_tags = [ "daily" ];
          template = "Daily";
        };

        picker = {
          # Currently, snacks.pick doesn't insert tags.
          # https://github.com/obsidian-nvim/obsidian.nvim/issues/73
          name = "telescope.nvim";
          # Optional; configure key mappings for the picker. These are the defaults.
          # Not all pickers support all mappings.
          note_mappings = {
            # Create a new note from your query.
            new = "<C-x>";
            # Insert a link to the selected note.
            insert_link = "<C-l>";
          };
          tag_mappings = {
            # Add tag(s) to current note.
            tag_note = "<C-x>";
            # Insert a tag at the current location.
            insert_tag = "<C-l>";
          };
        };
      };
    };

    keymaps =
      if isEnabled then
        [
          {
            mode = "n";
            key = "<leader>fo";
            action = ":Obsidian quick_switch<CR>";
            options.desc = "Find Obsidian Notes";
          }
          {
            mode = "n";
            key = "<leader>on";
            action = ":ON<CR>";
            options.desc = "New Note";
          }
          {
            mode = "n";
            key = "<leader>oo";
            action = ":Obsidian open<CR>";
            options.desc = "Open in Obsidian";
          }
          {
            mode = "n";
            key = "<leader>ot";
            action = ":Obsidian tags<CR>";
            options.desc = "Find Obsidian Tags";
          }
          {
            mode = "n";
            key = "<leader>op";
            action = ":Obsidian paste_img<CR>";
            options.desc = "Paste Image";
          }
          {
            mode = "n";
            key = "<leader>ob";
            action = ":Obsidian backlinks<CR>";
            options.desc = "Find Obsidian Backlinks";
          }
        ]
      else
        [ ];

  };
}
