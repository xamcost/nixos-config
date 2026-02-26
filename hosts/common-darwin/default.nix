{ pkgs, ... }:
{
  # Mac OS X configuration options
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults = {
    screencapture.location = "~/Pictures/screenshots";
    # Finder settings
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
  };

  nix.gc.interval = {
    Weekday = 0;
    Hour = 2;
    Minute = 0;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bruno # Postman alternative
    # bruno-cli
    kind # to run Kubernetes clusters using Docker
    kubectl
    kubernetes-helm
    rustup
  ];
}
