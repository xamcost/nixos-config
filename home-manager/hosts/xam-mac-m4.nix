{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./common
    ./common-darwin
    ../nixvim
  ];

  home.username = "maximecostalonga";
  home.homeDirectory = "/Users/maximecostalonga";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    cloudflared # Temporary, for Sedimark
    sops
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Sops secrets management
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./xam-mac-m4-secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.secrets = {
    "rclone/sedimark/url" = { };
    "rclone/sedimark/user" = { };
    "rclone/sedimark/password" = { };
  };

  programs = {
    rclone = {
      enable = true;
      remotes = {
        "sedimark" = {
          config = {
            type = "webdav";
            vendor = "owncloud";
          };
          secrets = {
            url = config.sops.secrets."rclone/sedimark/url".path;
            user = config.sops.secrets."rclone/sedimark/user".path;
            pass = config.sops.secrets."rclone/sedimark/password".path;
          };
          # mounts = {
          #   "SEDIMARK" = {
          #     enable = true;
          #     mountPoint =
          #       "${config.home.homeDirectory}/Documents/eviden/sedimark/owncloud";
          #     options = { vfs-cache-mode = "full"; };
          #   };
          # };
        };
      };
    };
  };
}
