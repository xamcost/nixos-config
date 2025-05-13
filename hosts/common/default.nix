{
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimize Nix store storage
  nix.optimise = { automatic = true; };
  # Garbage collect old generations
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
}
