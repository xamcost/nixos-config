{ config, pkgs, ... }:
{
  imports = [
    ./common
  ];

  home.username = "mcostalonga";
  home.homeDirectory = "/Users/mcostalonga";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    kitty
    kitty-themes
    monitorcontrol # To control external monitor brightness
    nixd # Nix language server
    nixpkgs-fmt # to format Nix code
    teamocil
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

  home.sessionVariables = {
    KUBECONFIG = "$(\ls -d $HOME/.kube/* | grep config- | tr '\n' ':')";
    DOCKER_HOST = "unix://$HOME/.colima/docker.sock"; # For Lazydocker to work with Colima
    # Pnpm
    PNPM_HOME = "$HOME/Library/pnpm";
    PATH = "$PNPM_HOME:$PATH";
  };

  programs = {
    zsh = {
      shellAliases = {
        "k" = "kubectl";
        "kchange" = "kubectl config use-context";
        "pyenv-ls" = "ls $HOME/.venv/";
        "pyenv-act" = "(){source $HOME/.venv/$1/bin/activate;}";
      };
    };
    k9s = {
      enable = true;
    };
  };
}
