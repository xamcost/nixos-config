{ config, ... }:
{
  sops.secrets.restic-local-pwd = { };

  services.restic.backups = {
    "local" = {
      repository = "/mnt/cocytos/backups/restic-local";
      paths = [
        "/mnt/tartaros"
        "/mnt/lethe"
      ];
      exclude = [
        "/mnt/lethe/calibre"
        "/mnt/lethe/couchdb"
        "/mnt/lethe/home_assistant"
        "/mnt/lethe/immich"
        "/mnt/lethe/paperless"
        "/mnt/lethe/zigbee2mqtt"
      ];
      passwordFile = config.sops.secrets.restic-local-pwd.path;
      initialize = true;
      timerConfig = {
        OnCalendar = "*-*-* 02:30:00";
        Persistent = true;
      };
      pruneOpts = [ "--keep-daily=7" ];
    };
  };
}
