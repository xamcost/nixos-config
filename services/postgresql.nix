{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      # ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      ensureDBOwnership = true;
    }];
  };

  services.postgresqlBackup = {
    enable = true;
    location = "/mnt/lethe/postgresql_backups/nextcloud";
    databases = [ "nextcloud" ];
    # time to start backup in systemd.time format
    startAt = "*-*-* 06:30:00";
  };

  # Ensure postgresql starts before apps that need it
  systemd = {
    services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };
}
