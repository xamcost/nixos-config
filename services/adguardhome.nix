{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    port = 3001;
    settings = {
      filters = map(url: { enabled = true; url = url; }) [
        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
      ];
    };
  };
}
