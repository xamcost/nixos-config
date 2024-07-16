{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    port = 3001;
    settings = {
      filters = map(url: { enabled = true; url = url; }) [
	"https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
	"https://adaway.org/hosts.txt"
        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
	"https://phishing.army/download/phishing_army_blocklist_extended.txt"
	"https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
	"https://o0.pages.dev/Lite/adblock.txt"
	"https://v.firebog.net/hosts/Easyprivacy.txt"
      ];
    };
  };
}
