{ config, ... }:
{
  sops.secrets.mosquitto-password = {};
  
  services.mosquitto = {
    enable = true;
    listeners = [
      {
	users.xam = {
	  acl = [
	    "readwrite #"
	  ];
	  hashedPasswordFile = config.sops.secrets.mosquitto-password.path;
	};
      }
    ];
    logType = [ "all" ];
  };
}
