{ config, lib, ... }:

{
  # sops.secrets.traefik-env = { restartUnits = [ "traefik.service" ]; };
  sops.secrets.domain = { };
  sops.secrets.homeserver-prefix = { };
  sops.secrets."traefik/cloudflare-email" = { };
  sops.secrets."traefik/cloudflare-api-key" = { };

  sops.templates."static.yaml".content = ''
    global:
      checkNewVersion: false
      sendAnonymousUsage: false
    api:
      insecure: false
      dashboard: true
    log:
      level: DEBUG
      compress: true
    entryPoints:
      web:
        address: ":80"
        asDefault: true
        http:
          redirections:
            entryPoint:
              to: websecure
              permanent: true
              scheme: https
      websecure:
        address: ":443"
        asDefault: true
        http:
          tls:
            certResolver: letsencrypt
            domains:
              - main: ${config.sops.placeholder.homeserver-prefix}.${config.sops.placeholder.domain}
                sans: ["*.${config.sops.placeholder.homeserver-prefix}.${config.sops.placeholder.domain}"]
    certificatesResolvers:
      letsencrypt:
        acme:
          email: ${config.sops.placeholder."traefik/cloudflare-email"}
          storage: ${config.services.traefik.dataDir}/acme.json
          keyType: EC384
          dnsChallenge:
            provider: cloudflare
            delayBeforeCheck: 120s
            resolvers:
              - 1.1.1.1:53
              - 1.0.0.1:53
    providers:
      file:
        filename: ${config.services.traefik.dataDir}/dynamic.yaml
  '';
  sops.templates."static.yaml".path = "${config.services.traefik.dataDir}/static.yaml";
  sops.templates."static.yaml".owner = "traefik";

  sops.templates."dynamic.yaml".content = ''
    http:
      middlewares:
        ratelimit:
          rateLimit:
            average: 100
            burst: 100
        compress:
          compress: true
        headers-default:
          headers:
            sslRedirect: true
            browserXssFilter: true
            contentTypeNosniff: true
            forceSTSHeader: true
            stsIncludeSubdomains: true
            stsPreload: true
            stsSeconds: 15552000
            referrerPolicy: "same-origin"
            customFrameOptionsValue: "allow-from https:${config.sops.placeholder.domain}"
            customRequestHeaders:
              X-Forwarded-Proto: "https"
        chain-no-auth:
          chain:
            middlewares:
              - ratelimit
              - compress
              - headers-default
      routers:
        traefik:
          rule: "Host(`traefik.${config.sops.placeholder.domain}`)"
          service: "api@internal"
          middlewares:
            - chain-no-auth
          # tls:
          #   certResolver: letsencrypt
          tls: {}
        adguardhome:
          rule: "Host(`adguardhome.${config.sops.placeholder.domain}`)"
          service: "adguardhome"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        couchdb:
          rule: "Host(`couchdb.${config.sops.placeholder.domain}`)"
          service: "couchdb"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        home-assistant:
          rule: "Host(`home-assistant.${config.sops.placeholder.domain}`)"
          service: "home-assistant"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        influxdb:
          rule: "Host(`influxdb.${config.sops.placeholder.domain}`)"
          service: "influxdb"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        zigbee2mqtt:
          rule: "Host(`zigbee2mqtt.${config.sops.placeholder.domain}`)"
          service: "zigbee2mqtt"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        grafana:
          rule: "Host(`grafana.${config.sops.placeholder.domain}`)"
          service: "grafana"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        paperless:
          rule: "Host(`paperless.${config.sops.placeholder.domain}`)"
          service: "paperless"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        immich:
          rule: "Host(`immich.${config.sops.placeholder.domain}`)"
          service: "immich"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        glance:
          rule: "Host(`glance.${config.sops.placeholder.domain}`)"
          service: "glance"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        languagetool:
          rule: "Host(`languagetool.${config.sops.placeholder.domain}`)"
          service: "languagetool"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        nextcloud:
          rule: "Host(`nextcloud.${config.sops.placeholder.domain}`)"
          service: "nextcloud"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
        calibre-web:
          rule: "Host(`calibre.${config.sops.placeholder.domain}`)"
          service: "calibre-web"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
      services:
        adguardhome:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:3001"
        couchdb:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:5984"
        home-assistant:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8123"
        influxdb:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8086"
        zigbee2mqtt:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8099"
        grafana:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:3000"
        paperless:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:${toString config.services.paperless.port}"
        immich:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:2283"
        glance:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8087"
        languagetool:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:${toString config.services.languagetool.port}"
        nextcloud:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8081"
        calibre-web:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8083"
  '';
  sops.templates."dynamic.yaml".path = "${config.services.traefik.dataDir}/dynamic.yaml";
  sops.templates."dynamic.yaml".owner = "traefik";

  sops.templates."traefik.env" = {
    owner = "traefik";
    path = "${config.services.traefik.dataDir}/traefik.env";
    content = ''
      CLOUDFLARE_EMAIL=${config.sops.placeholder."traefik/cloudflare-email"}
      CLOUDFLARE_API_KEY=${config.sops.placeholder."traefik/cloudflare-api-key"}
    '';
  };

  systemd.services.traefik = {
    serviceConfig.EnvironmentFile = [ config.sops.templates."traefik.env".path ];
  };

  services.traefik = {
    enable = true;
    # environmentFiles = [ config.sops.templates."traefik.env".path ];
    staticConfigFile = config.sops.templates."static.yaml".path;
    dynamicConfigFile = config.sops.templates."dynamic.yaml".path;
  };
}
