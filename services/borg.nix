{ config, ... }:
{
  sops.secrets.borg-lethe-passphrase = {};

  services.borgbackup.jobs = {
    "lethe" = {
      repo = "/mnt/cocytos/backups/lethe";
      paths = [
        "/mnt/lethe"
      ];
      compression = "lz4";
      encryption = {
	mode = "repokey";
	passCommand = "cat ${config.sops.secrets.borg-lethe-passphrase.path}";
      };
      startAt = "*-*-* 02:30:00";
    };
  };
}

