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
          dnsChallenge:
            provider: cloudflare
            delayBeforeCheck: 120s
            resolvers:
              - 1.1.1.1:53
              - 8.8.8.8:53
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
          entryPoints:
            - websecure
          service: "api@internal"
          middlewares:
            - chain-no-auth
          tls:
            certResolver: letsencrypt
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
