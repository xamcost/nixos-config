{ pkgs, lib, inputs, self, ... }: {
  imports = [ ../common-darwin ../common ];

  # Mac OS X configuration options
  system.defaults.loginwindow.LoginwindowText = "MacAtos";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
