{ config, lib, ... }:
let
  resources = {
    yt = 6;
    rss = 1;
    subreddit = 1;
    svc = 7;
  };

  generateSecretKeys = type: count:
    lib.genList (num: 
      let
        n = num + 1;
        nStr = if n < 10 then "0${toString n}" else toString n;
      in
      "glance/${type}${nStr}"
    ) count;
    
  # Flatten the list of all secret keys
  allSecretKeys = lib.flatten (lib.mapAttrsToList generateSecretKeys resources);
  
  # Create secrets object from keys
  secretsObj = lib.listToAttrs (map (key: { name = key; value = {}; }) allSecretKeys);
  
  # Generate environment variable assignments
  generateEnvVars = key:
    let
      baseName = builtins.elemAt (builtins.split "/" key) 2;
      envName = lib.toUpper baseName;
    in
    "${envName} = \${config.sops.placeholder.\"${key}\"}";
    
  envContent = lib.concatStringsSep "\n" (map generateEnvVars allSecretKeys);

in
{
  sops.secrets = secretsObj;

  sops.templates."glance.env".content = envContent;

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
                      type = "group";
                      widgets = [
                        {
                          type = "reddit";
                          style = "vertical-list";
                          subreddit = "\${SUBREDDIT01}";
                        }
                      ];
                    }
                    {
                      type = "group";
                      widgets = [
                        {
                          type = "hacker-news";
                          style = "vertical-list";
                        }
                        {
                          type = "lobsters";
                          style = "vertical-list";
                          sort-by = "hot";
                          limit = 15;
                          collapse-after = 5;
                          tags = [
                            "security"
                            "practices"
                            "programming"
                            "python"
                            "hardware"
                            "mac"
                            "linux"
                            "devops"
                            "web"
                            "rust"
                          ];
                        }
                      ];
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
                    {
                      title = "Stirling PDF";
                      url = "\${SVC07}";
                      icon = "di:stirling-pdf";
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
