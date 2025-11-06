{ config, ... }:
{
  sops.secrets.domain = { };
  sops.secrets."navidrome/password-encryption-key" = { };
  sops.secrets."navidrome/lastfm-api-key" = { };
  sops.secrets."navidrome/lastfm-secret" = { };

  sops.templates."navidrome.env".content = ''
    ND_BASEURL=https://navidrome.${config.sops.placeholder.domain}
    ND_DEEZER_ENABLED=true
    ND_LASTFM_ENABLED=true
    ND_LASTFM_APIKEY=${config.sops.placeholder."navidrome/lastfm-api-key"}
    ND_LASTFM_SECRET=${config.sops.placeholder."navidrome/lastfm-secret"}
    ND_PASSWORDENCRYPTIONKEY=${config.sops.placeholder."navidrome/password-encryption-key"}
  '';

  services.navidrome = {
    enable = true;
    environmentFile = config.sops.templates."navidrome.env".path;
    settings = {
      EnableInsightsCollector = false;
      MusicFolder = "/mnt/lethe/music";
      DataFolder = "/mnt/tartaros/navidrome/data";
      Agents = "lastfm,spotify,deezer";
    };
  };
}
