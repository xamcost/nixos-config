{ config, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9090;
    globalConfig.scrape_interval = "15m";
    scrapeConfigs = [
      {
        job_name = "elysium";
	scrape_interval = "1m";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
  };
}
