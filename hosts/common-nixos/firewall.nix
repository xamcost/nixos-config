{
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
	22
      ];
    };
  };
}
