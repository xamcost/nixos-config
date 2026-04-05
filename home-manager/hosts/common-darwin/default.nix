{ pkgs, ... }:
{
  home.packages = with pkgs; [
    colima
    devcontainer
    lima-additional-guestagents # To emulate non-native architectures
    docker
    docker-buildx # For multi-platform builds
    kitty
    kitty-themes
    monitorcontrol # To control external monitor brightness
    nixd # Nix language server
    nixpkgs-fmt # to format Nix code
    # nurl # To generate nix fetcher from repo URLs
    pinentry-curses # For rbw
    pngpaste # For pasting images in nvim
    podman-compose
    python313
    rbw # Bitwarden CLI client
    sshuttle # For VPN-like SSH tunnels
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
    POETRY_VIRTUALENVS_IN_PROJECT = "true"; # To have venv created in project directory instead of global .venv
  };

  home.sessionPath = [
    "/opt/podman/bin" # To have podman in PATH on macOS, couldn't install podman via nixpkgs
  ];

  home.file = {
    ".colima/_templates/default.yaml".source = ../../dotfiles/colima/_templates/default.yaml;
    ".config/kitty/".source = ../../dotfiles/config/kitty;
    ".teamocil/".source = ../../dotfiles/teamocil;
    ".config/opencode/agent/".source = ../../dotfiles/config/opencode/agent;
    ".config/opencode/config.json".source = ../../dotfiles/config/opencode/config.json;
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
