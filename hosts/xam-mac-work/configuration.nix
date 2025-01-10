{ pkgs, lib, inputs, self, ... }: {
  # Mac OS X configuration options
  security.pam.enableSudoTouchIdAuth = true;
  system.defaults = {
    loginwindow.LoginwindowText = "MacAtos";
    screencapture.location = "~/Pictures/screenshots";
    # Finder settings
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    k2tf # to convert Kubernetes resources to Terraform
    kind # to run Kubernetes clusters using Docker
    newman # to run Postman collections from the command line
    opentofu
    postgresql_15
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

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

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
