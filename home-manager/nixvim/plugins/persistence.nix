{ config, lib, ... }:
{
  programs.nixvim = {
    plugins.persistence = {
      enable = true;
    };

    plugins.which-key.settings.spec = lib.mkIf config.programs.nixvim.plugins.persistence.enable [
      {
        __unkeyed-1 = "<leader>S";
        mode = "n";
        icon = " ";
        group = "Session";
      }
    ];

    keymaps = lib.mkIf config.programs.nixvim.plugins.persistence.enable [
      {
        mode = "n";
        key = "<leader>Ss";
        action = {
          __raw = ''function() require("persistence").load() end'';
        };
        options = {
          desc = "Restore Session";
        };
      }
      {
        mode = "n";
        key = "<leader>Sl";
        action = {
          __raw = ''function() require("persistence").load({ last = true }) end'';
        };
        options = {
          desc = "Restore Last Session";
        };
      }
      {
        mode = "n";
        key = "<leader>Sd";
        action = {
          __raw = ''function() require("persistence").stop() end'';
        };
        options = {
          desc = "Stop Session";
        };
      }
    ];
  };
}
