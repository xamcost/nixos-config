{
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimize Nix store storage
  nix.optimise = { automatic = true; };
  # Garbage collect old generations
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
}
