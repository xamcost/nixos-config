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
	    referrerPolicy = "same-origin"
	    customFrameOptionsValue = "allow-from https:${config.sops.placeholder.domain}"
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

        [http.routers.freshrss]
          rule = "Host(`freshrss.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "freshrss"

          [http.routers.freshrss.tls]
            certResolver = "cloudflare"

        [http.routers.calibre]
          rule = "Host(`calibre.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "calibre"

          [http.routers.calibre.tls]
            certResolver = "cloudflare"

        [http.routers.immich]
          rule = "Host(`immich.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "immich"

          [http.routers.immich.tls]
            certResolver = "cloudflare"

        [http.routers.grafana]
          rule = "Host(`grafana.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "grafana"

          [http.routers.grafana.tls]
            certResolver = "cloudflare"

        [http.routers.couchdb]
          rule = "Host(`couchdb.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "couchdb"

          [http.routers.couchdb.tls]
            certResolver = "cloudflare"

        [http.routers.home-assistant]
          rule = "Host(`home-assistant.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "home-assistant"

          [http.routers.home-assistant.tls]
            certResolver = "cloudflare"

        [http.routers.influxdb]
          rule = "Host(`influxdb.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "influxdb"

          [http.routers.influxdb.tls]
            certResolver = "cloudflare"

        [http.routers.zigbee2mqtt]
          rule = "Host(`zigbee2mqtt.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "zigbee2mqtt"

          [http.routers.zigbee2mqtt.tls]
            certResolver = "cloudflare"

        [http.routers.jellyfin]
          rule = "Host(`jellyfin.${config.sops.placeholder.domain}`)"
          entryPoints = ["websecure"]
	  middlewares = ["headers-default"]
          service = "jellyfin"

          [http.routers.jellyfin.tls]
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

        [http.services.freshrss]
          [http.services.freshrss.loadBalancer]
            [[http.services.freshrss.loadBalancer.servers]]
              url = "http://127.0.0.1:8082"

        [http.services.calibre]
          [http.services.calibre.loadBalancer]
            [[http.services.calibre.loadBalancer.servers]]
              url = "http://127.0.0.1:8083"

        [http.services.immich]
          [http.services.immich.loadBalancer]
            [[http.services.immich.loadBalancer.servers]]
              url = "http://127.0.0.1:2283"

        [http.services.grafana]
          [http.services.grafana.loadBalancer]
            [[http.services.grafana.loadBalancer.servers]]
              url = "http://127.0.0.1:3000"

        [http.services.couchdb]
          [http.services.couchdb.loadBalancer]
            [[http.services.couchdb.loadBalancer.servers]]
              url = "http://127.0.0.1:5984"

        [http.services.home-assistant]
          [http.services.home-assistant.loadBalancer]
            [[http.services.home-assistant.loadBalancer.servers]]
              url = "http://127.0.0.1:8123"

        [http.services.influxdb]
          [http.services.influxdb.loadBalancer]
            [[http.services.influxdb.loadBalancer.servers]]
              url = "http://127.0.0.1:8086"

        [http.services.zigbee2mqtt]
          [http.services.zigbee2mqtt.loadBalancer]
            [[http.services.zigbee2mqtt.loadBalancer.servers]]
              url = "http://127.0.0.1:8099"

        [http.services.jellyfin]
          [http.services.jellyfin.loadBalancer]
            [[http.services.jellyfin.loadBalancer.servers]]
              url = "http://127.0.0.1:8096"
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
