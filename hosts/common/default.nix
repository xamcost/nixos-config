{ pkgs, ...}: {
  imports = [
    ./firewall.nix
    ./locale.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sops
    pkgs.home-manager
  ];

  programs = {
    git.enable = true;
    zsh.enable = true;
  };

  # Optimize Nix store storage
  nix.optimise = {
    automatic = true;
  };
  # Garbage collect old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
