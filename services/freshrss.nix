{ config, ... }:
{
  sops.secrets.freshrss-password = {};
  sops.secrets.domain = {};

  sops.templates."freshrss.env".content = ''
    ADMIN_EMAIL=admin@freshrss.com
    PUBLISHED_PORT=8082
    ADMIN_PASSWORD=${config.sops.placeholder.freshrss-password}
    ADMIN_API_PASSWORD=${config.sops.placeholder.freshrss-password}
    BASE_URL=https://freshrss.${config.sops.placeholder.domain}
    TZ=Europe/London
    CRON_MIN=1,31
  '';

  virtualisation.oci-containers.containers."freshrss" = {
    image = "freshrss/freshrss:latest";
    autoStart = true;
    environmentFiles = [
      config.sops.templates."freshrss.env".path
    ];
    volumes = [
      "data:/var/www/FreshRSS/data"
      "extensions:/var/www/FreshRSS/extensions"
    ];
    ports = [
      "8082:80"
    ];
  };
}
