{ config, ... }:
{
  sops.secrets = {
    "glance/yt01" = {};
    "glance/yt02" = {};
    "glance/yt03" = {};
    "glance/yt04" = {};
    "glance/yt05" = {};
    "glance/yt06" = {};

    "glance/rss01"= {};

    "glance/subreddit01" = {};

    "glance/svc01" = {};
    "glance/svc02" = {};
    "glance/svc03" = {};
    "glance/svc04" = {};
    "glance/svc05" = {};
    "glance/svc06" = {};
  };

  sops.templates."glance.env".content = ''
    YT01 = ${config.sops.placeholder."glance/yt01"}
    YT02 = ${config.sops.placeholder."glance/yt02"}
    YT03 = ${config.sops.placeholder."glance/yt03"}
    YT04 = ${config.sops.placeholder."glance/yt04"}
    YT05 = ${config.sops.placeholder."glance/yt05"}
    YT06 = ${config.sops.placeholder."glance/yt06"}
    RSS01 = ${config.sops.placeholder."glance/rss01"}
    SUBREDDIT01 = ${config.sops.placeholder."glance/subreddit01"}
    SVC01 = ${config.sops.placeholder."glance/svc01"}
    SVC02 = ${config.sops.placeholder."glance/svc02"}
    SVC03 = ${config.sops.placeholder."glance/svc03"}
    SVC04 = ${config.sops.placeholder."glance/svc04"}
    SVC05 = ${config.sops.placeholder."glance/svc05"}
    SVC06 = ${config.sops.placeholder."glance/svc06"}
  '';

  services.glance = {
    enable = true;
    settings = {
      server = {
        port = 8087;
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                }
                {
                  type = "weather";
                  location = "London, United Kingdom";
                  hourFormat = "24h";
                }
                {
                  type = "clock";
                  hourFormat = "24h";
                  timezones = [
                    {
                      timezone = "Europe/Paris";
                      label = "Paris";
                    }
                    {
                      timezone = "America/Los_Angeles";
                      label = "Berkeley";
                    }
                    {
                      timezone = "Asia/Shanghai";
                      label = "Changzhou";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "rss";
                  style = "horizontal-cards";
                  feeds = [
                    {
                      url = "\${RSS01}";
                    }
                  ];
                }
                {
                  type = "split-column";
                  widgets = [
                    {
                      type = "reddit";
                      style = "vertical-list";
                      subreddit = "\${SUBREDDIT01}";
                    }
                    {
                      type = "hacker-news";
                      style = "vertical-list";
                    }
                  ];
                }
                {
                  type = "videos";
                  style = "horizontal-cards";
                  channels = [
                    "\${YT01}"
                    "\${YT02}"
                    "\${YT03}"
                    "\${YT04}"
                    "\${YT05}"
                    "\${YT06}"
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "monitor";
                  title = "Services";
                  sites = [
                    {
                      title = "Home Assistant";
                      url = "\${SVC01}";
                      icon = "di:home-assistant";
                    }
                    {
                      title = "Grafana";
                      url = "\${SVC02}";
                      icon = "di:grafana";
                    }
                    {
                      title = "Nextcloud";
                      url = "\${SVC03}";
                      icon = "di:nextcloud";
                    }
                    {
                      title = "Immich";
                      url = "\${SVC04}";
                      icon = "di:immich";
                    }
                    {
                      title = "AdGuard Home";
                      url = "\${SVC05}";
                      icon = "di:adguard-home";
                    }
                    {
                      title = "Calibre";
                      url = "\${SVC06}";
                      icon = "di:calibre-web";
                    }
                  ];
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "Elysium";
                      mountpoints = {
                        "/" = {
                          name = "root";
                        };
                        "/boot" = {
                          name = "boot";
                        };
                        "/mnt/lethe" = {
                          name = "lethe";
                        };
                        "/mnt/tartaros" = {
                          name = "tartaros";
                        };
                        "/mnt/cocytos" = {
                          name = "cocytos";
                        };
                      };
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };

  systemd.services.glance = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."glance.env".path;
    };
  };
}
