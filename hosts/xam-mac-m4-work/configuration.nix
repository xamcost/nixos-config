{
  pkgs,
  lib,
  inputs,
  self,
  ...
}:
{
  imports = [
    ../common-darwin
  ];

  nix.enable = false;

  users.users.maximecostalonga = {
    name = "maximecostalonga";
    home = "/Users/maximecostalonga";
  };

  services = {
    yabai = {
      enable = false;
      # extraConfig = ''
      #   yabai -m config mouse_follows_focus off
      #   yabai -m config focus_follows_mouse off
      #   yabai -m config window_shadow off
      #   yabai -m config window_opacity on
      #   yabai -m config window_opacity_duration 0.2
      #   yabai -m config active_window_opacity 1.0
      #   yabai -m config normal_window_opacity 0.9
      # '';
    };

    skhd = {
      enable = false;
      skhdConfig = ''
        # Yabai
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus previous
        alt - k : yabai -m window --focus next
        alt - l : yabai -m window --focus east

        alt + shift - h : yabai -m window --swap west
        alt + shift - j : yabai -m window --swap south
        alt + shift - k : yabai -m window --swap north
        alt + shift - l : yabai -m window --swap east

        alt + ctrl - h : yabai -m window --space west
        alt + ctrl - j : yabai -m window --space south
        alt + ctrl - k : yabai -m window --space north
        alt + ctrl - l : yabai -m window --space east
        al

        # Alt + Ctrl + Shift to move windows between spaces
      '';
    };
  };

  system.primaryUser = "maximecostalonga";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
