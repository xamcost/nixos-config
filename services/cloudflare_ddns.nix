{config, ...}: {
  sops.secrets.cloudflare-ddns-token = {};
  sops.secrets.home-prefix = {};
  sops.secrets.domain = {};

  sops.templates."cloudflare-ddns.env".content = ''
    CLOUDFLARE_DOMAINS="${config.sops.placeholder.home-prefix}.${config.sops.placeholder.domain}"
  '';

  services.cloudflare-dyndns = {
    enable = true;
    frequency = "*:0/15";
    apiTokenFile = config.sops.secrets.cloudflare-ddns-token.path;
  };

  systemd.services.cloudflare-dyndns = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-ddns.env".path;
    };
  };
}
