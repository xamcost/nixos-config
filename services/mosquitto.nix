{ config, ... }:
{
  sops.secrets.mosquitto-xam-password = { };
  sops.secrets.mosquitto-z2m-password = { };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.xam = {
          acl = [
            "readwrite #"
          ];
          passwordFile = config.sops.secrets.mosquitto-xam-password.path;
        };
        users.z2m = {
          acl = [
            "readwrite #"
          ];
          passwordFile = config.sops.secrets.mosquitto-z2m-password.path;
        };
      }
    ];
    logType = [ "all" ];
  };
}
