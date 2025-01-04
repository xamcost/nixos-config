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

  # Optimize Nix store storage
  nix.optimise = {
    automatic = true;
  };
  # Garbage collect old generations
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 30d";
  };
}
