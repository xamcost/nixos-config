{ config, ... }:
{
  sops.secrets.grafana-password = {
    owner = "grafana";
  };

  services.grafana = {
    enable = true;
    settings = {
      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.sops.secrets.grafana-password.path}}";
      };
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];
    };
  };
}
