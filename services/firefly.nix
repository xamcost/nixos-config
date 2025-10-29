{ config, ... }:
let
  virtualHost = "firefly";
in
{
  sops.secrets."firefly-iii/app-key" = {
    owner = "firefly-iii";
  };
  sops.templates."firefly-iii.env".content = ''
    APP_KEY=${config.sops.placeholder."firefly-iii/app-key"}
    APP_URL=https://firefly.${config.sops.placeholder.domain}
    TRUSTED_PROXIES=**
    TZ=Europe/London
    ENABLE_EXCHANGE_RATES=true
    ENABLE_EXTERNAL_RATES=true
  '';

  services.firefly-iii = {
    enable = true;
    dataDir = "/mnt/tartaros/firefly-iii";
    enableNginx = true;
    virtualHost = virtualHost;
    settings = {
      APP_KEY_FILE = config.sops.secrets."firefly-iii/app-key".path;
    };
  };

  # Set port manually
  services.nginx.virtualHosts."${virtualHost}".listen = [
    {
      addr = "127.0.0.1";
      port = 8084;
    }
  ];

  systemd.services.firefly-iii-setup = {
    serviceConfig.EnvironmentFile = [ config.sops.templates."firefly-iii.env".path ];
  };
}
