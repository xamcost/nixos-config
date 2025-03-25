{
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
                # {
                #   type = "server-stats";
                #   servers = [
                #     {
                #       type = "local";
                #       name = "Elysium";
                #       mountpoints = {
                #         "/" = {
                #           name = "root";
                #         };
                #         "/boot" = {
                #           name = "boot";
                #         };
                #         "/mnt/lethe" = {
                #           name = "lethe";
                #         };
                #         "/mnt/tartaros" = {
                #           name = "tartaros";
                #         };
                #         "/mnt/cocytos" = {
                #           name = "cocytos";
                #         };
                #       };
                #     }
                #   ];
                # }
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
                      title = "SMBC";
                      url = "https://www.smbc-comics.com/comic/rss";
                    }
                  ];
                }
                {
                  type = "split-column";
                  widgets = [
                    {
                      type = "reddit";
                      style = "vertical-list";
                      subreddit = "selfhosted";
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
                    "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                    "UCWYRT-NhEqkZ_afrqEgxYOQ" # Jimmy the giant
                    "UC5--wS0Ljbin1TjWQX6eafA" # Big Box SWE 
                    "UC_zBdZ0_H_jn41FDRG7q4Tw" # Vimjoyer
                    "UC54SLBnD5k5U3Q6N__UjbAw" # Chinese Cooking Demystified
                    "UCbgBDBrwsikmtoLqtpc59Bw" # Teaching Tech
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
