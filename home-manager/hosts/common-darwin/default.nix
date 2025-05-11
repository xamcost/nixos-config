{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
    kitty-themes
    monitorcontrol # To control external monitor brightness
    nixd # Nix language server
    nixpkgs-fmt # to format Nix code
    # nurl # To generate nix fetcher from repo URLs
    teamocil
    translate-shell # CLI translator
  ];

  home.sessionVariables = {
    KUBECONFIG = ''
      $(ls -d $HOME/.kube/* | grep config- | tr '
      ' ':')'';
    DOCKER_HOST =
      "unix://$HOME/.colima/docker.sock"; # For Lazydocker to work with Colima
    # Pnpm
    PNPM_HOME = "$HOME/Library/pnpm";
    PATH = "$PNPM_HOME:$PATH";
  };

  programs = {
    k9s = { enable = true; };

    zsh = {
      shellAliases = {
        "k" = "kubectl";
        "kchange" = "kubectl config use-context";
        "pyenv-ls" = "ls $HOME/.venv/";
        "pyenv-act" = "(){source $HOME/.venv/$1/bin/activate;}";
      };
    };
  };
}
