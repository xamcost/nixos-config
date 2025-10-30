{ pkgs, ... }:
{
  home.packages = with pkgs; [
    colima
    lima-additional-guestagents # To emulate non-native architectures
    docker
    docker-buildx # For multi-platform builds
    kitty
    kitty-themes
    monitorcontrol # To control external monitor brightness
    nixd # Nix language server
    nixpkgs-fmt # to format Nix code
    # nurl # To generate nix fetcher from repo URLs
    pngpaste # For pasting images in nvim
    python313
    teamocil
    translate-shell # CLI translator
  ];

  home.sessionVariables = {
    KUBECONFIG = ''
      $(ls -d $HOME/.kube/* | grep config- | tr '
      ' ':')'';
    DOCKER_HOST = "unix://$HOME/.colima/docker.sock"; # For Lazydocker to work with Colima
    # Pnpm
    PNPM_HOME = "$HOME/Library/pnpm";
    PATH = "$PNPM_HOME:$PATH";
  };

  home.file = {
    ".colima/_templates/default.yaml".source = ../../dotfiles/colima/_templates/default.yaml;
    ".config/kitty/".source = ../../dotfiles/config/kitty;
    ".teamocil/".source = ../../dotfiles/teamocil;
    ".config/opencode/agent/".source = ../../dotfiles/config/opencode/agent;
  };

  programs = {
    k9s = {
      enable = true;
    };

    zsh = {
      shellAliases = {
        "k" = "kubectl";
        "kchange" = "kubectl config use-context";
        "pyenv-ls" = "ls $HOME/.venv/";
        "pyenv-act" = "(){source $HOME/.venv/$1/bin/activate;}";
        "pyenv-rm" = "rm -rf $HOME/.venv/$1";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
      extensions = [
        pkgs.gh-notify
        pkgs.gh-dash
      ];
    };

    lazydocker.enable = true;

    # Python package and project manager
    uv = {
      enable = true;
    };
  };
}
