{ pkgs, ... }: {
  imports = [ ./firewall.nix ./locale.nix ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ sops pkgs.home-manager ];

  nix.gc.dates = "weekly";

  programs = {
    git.enable = true;
    zsh.enable = true;
  };
}
