{ config, lib, ... }:

let
  services = [
    { name = "adguardhome"; port = 3001; noMiddleware = true; }
    { name = "nextcloud"; port = 8081; }
    { name = "calibre"; port = 8083; }
    { name = "immich"; port = 2283; }
    { name = "grafana"; port = 3000; }
    { name = "couchdb"; port = 5984; }
    { name = "home-assistant"; port = 8123; }
    { name = "influxdb"; port = 8086; }
    { name = "zigbee2mqtt"; port = 8099; }
    { name = "jellyfin"; port = 8096; }
    { name = "glance"; port = 8087; }
    { name = "stirling"; port = 8088; }
  ];

  generateRouter = service: ''
    [http.routers.${service.name}]
      rule = "Host(`${service.name}.${config.sops.placeholder.domain}`)"
      entryPoints = ["websecure"]
      ${if !(service.noMiddleware or false) then ''middlewares = ["headers-default"]'' else ""}
      service = "${service.name}"

      [http.routers.${service.name}.tls]
        certResolver = "cloudflare"
  '';

  generateService = service: 
    ''
      [http.services.${service.name}]
        [http.services.${service.name}.loadBalancer]
          [[http.services.${service.name}.loadBalancer.servers]]
            url = "http://127.0.0.1:${toString service.port}"
    '';

  allRouters = lib.concatStringsSep "\n\n" (map generateRouter services);
  allServices = lib.concatStringsSep "\n\n" (map generateService services);
in
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

${allRouters}

      [http.services]
${allServices}
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
