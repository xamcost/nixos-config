{ pkgs, ...}: {
  imports = [
    ./firewall.nix
    ./locale.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    sops
    pkgs.lazygit
    pkgs.home-manager
  ];

  programs = {
    git.enable = true;
    zsh.enable = true;
  };
}
