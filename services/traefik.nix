{ config, ... }:
{
  sops.secrets.traefik-env = {
    restartUnits = [ "traefik.service" ];
  };
  sops.secrets.domain = {};
  sops.secrets.homeserver-prefix = {};

  sops.templates."traefik.toml".content = ''
    [api]
      dashboard = true

    [log]
      level = "DEBUG"

    [serversTransport]
      insecureSkipVerify = true

    [entryPoints]
      [entryPoints.web]
        address = ":80"
        [entryPoints.web.http]
          [entryPoints.web.http.redirections]
            [entryPoints.web.http.redirections.entryPoint]
              to = "websecure"
              scheme = "https"
      [entryPoints.websecure]
        address = ":443"
        [entryPoints.websecure.http]
          [entryPoints.websecure.http.tls]
            certResolver = "cloudflare"

            [[entryPoints.websecure.http.tls.domains]]
              main = "${config.sops.placeholder.homeserver-prefix}.${config.sops.placeholder.domain}"
              sans = ["*.${config.sops.placeholder.homeserver-prefix}.${config.sops.placeholder.domain}"]

    [certificatesResolvers]
      [certificatesResolvers.cloudflare]
        [certificatesResolvers.cloudflare.acme]
	  storage = "${config.services.traefik.dataDir}/acme.json"
	  [certificatesResolvers.cloudflare.acme.dnsChallenge]
	    provider = "cloudflare"
	    resolvers = ["1.1.1.1:53", "8.8.8.8:53"]

    [providers]
      [providers.file]
        filename = "${config.sops.templates."config.toml".path}"
	watch = true
  '';
  sops.templates."traefik.toml".path = "/etc/traefik/traefik.toml";
  sops.templates."traefik.toml".owner = "traefik";

  sops.templates."config.toml".content = ''
    [http]
      [http.middlewares]
      	[http.middlewares.headers-default]
          [http.middlewares.headers-default.headers]
	    sslRedirect = true
	    browserXssFilter = true
	    contentTypeNosniff = true
	    forceSTSHeader = true
	    stsIncludeSubdomains = true
	    stsPreload = true
	    stsSeconds = 15552000
	    customFrameOptionsValue = "SAMEORIGIN"
	    [http.middlewares.headers-default.headers.customRequestHeaders]
	      X-Forwarded-Proto = "https"

      [http.routers]
        [http.routers.traefik]
          rule = "Host(`traefik.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
          service = "api@internal"

          [http.routers.traefik.tls]
            certResolver = "cloudflare"

        [http.routers.adguardhome]
          rule = "Host(`adguardhome.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
          service = "adguardhome"

          [http.routers.adguardhome.tls]
            certResolver = "cloudflare"

        [http.routers.nextcloud]
          rule = "Host(`nextcloud.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "nextcloud"

          [http.routers.nextcloud.tls]
            certResolver = "cloudflare"

      [http.services]
        [http.services.adguardhome]
          [http.services.adguardhome.loadBalancer]
            [[http.services.adguardhome.loadBalancer.servers]]
              url = "http://127.0.0.1:3001"

        [http.services.nextcloud]
          [http.services.nextcloud.loadBalancer]
            [[http.services.nextcloud.loadBalancer.servers]]
              url = "http://127.0.0.1:8081"
  '';
  sops.templates."config.toml".path = "/etc/traefik/config.toml";
  sops.templates."config.toml".owner = "traefik";

  services.traefik = {
    enable = true;
    environmentFiles = [
      config.sops.secrets.traefik-env.path
    ];
    staticConfigFile = config.sops.templates."traefik.toml".path;
    dynamicConfigFile = config.sops.templates."config.toml".path;
  };
}
