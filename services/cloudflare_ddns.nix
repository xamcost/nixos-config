{ config, ... }:
{
  sops.secrets.cloudflare-ddns-token = {};
  sops.secrets.cloudflare-zoneid = {};
  sops.secrets.home-prefix = {};
  sops.secrets.domain = {};

  sops.templates."cloudflare-ddns.env".content = ''
    CF_DNS__DOMAINS_0__ZONE_ID=${config.sops.placeholder.cloudflare-zoneid}
    CF_DNS__AUTH__SCOPED_TOKEN=${config.sops.placeholder.cloudflare-ddns-token}
    CF_DNS__DOMAINS_0__NAME=${config.sops.placeholder.home-prefix}.${config.sops.placeholder.domain}
    CF_DNS__CRON="*/15 * * * *"
    CF_DNS__DOMAINS_0__TYPE=A
    CF_DNS__DOMAINS_0__PROXIED=false
  '';

  virtualisation.oci-containers.containers."cloudflare_ddns" = {
    image = "ghcr.io/joshuaavalon/cloudflare-ddns:latest";
    environmentFiles = [
      config.sops.templates."cloudflare-ddns.env".path
    ];
  };
}
