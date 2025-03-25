{ config, lib, ... }:
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
