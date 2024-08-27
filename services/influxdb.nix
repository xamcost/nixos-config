{ config, ... }:
{
  sops.secrets.influxdb-password = { owner = "influxdb2"; };
  sops.secrets.influxdb-token = { owner = "influxdb2"; };

  services.influxdb2 = {
    enable = true;
    provision = {
      enable = true;
      initialSetup = {
        username = "xam";
	passwordFile = config.sops.secrets.influxdb-password.path;
	tokenFile = config.sops.secrets.influxdb-token.path;
	organization = "influxdata";
	bucket = "home_assistant";
      };
    };
  };
}
