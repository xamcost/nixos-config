{ config, ... }:
{
  sops.secrets.nextcloud-password = {
    owner = "nextcloud";
  };
  sops.templates."nextcloud-config.json".content = ''
    {
      "trusted_domains": [
	"127.0.0.1",
	"nextcloud.${config.sops.placeholder.domain}"
      ]
    }
  '';
  sops.templates."nextcloud-config.json".owner = "nextcloud";

  services.nextcloud = {
    enable = true;
    datadir = "/mnt/lethe/nextcloud";
    database.createLocally = true;
    hostName = "localhost";
    autoUpdateApps.enable = true;
    # https = true; # Traefik takes care of this
    maxUploadSize = "5G";
    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
    };
    caching.redis = true;
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      # default directory for postgresql, ensures automatic setup of db
      dbhost = "/run/postgresql";
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-password.path;
    };
    settings = {
      trusted_proxies = ["127.0.0.1"];
      overwriteprotocol = "https"; # Needed for clients because of reverse proxy
      default_phone_region = "GB";
      maintenance_window_start = 1; # To run maintenance tasks between 1 am and 5 am
      log_type = "file";
      redis = {
        host = "127.0.0.1";
        port = 31638;
        dbindex = 0;
        timeout = 1.5;
      };
    };
    secretFile = config.sops.templates."nextcloud-config.json".path;
  };

  # Change the port to 8081 to avoid conflicts with Traefik
  services.nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8081; } ];
}
