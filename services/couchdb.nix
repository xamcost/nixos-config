{ config, ... }:
{
  sops.secrets.couchdb-password = { };

  sops.templates."couchdb.env".content = ''
    COUCHDB_USER=admin
    COUCHDB_PASSWORD=${config.sops.placeholder.couchdb-password}
  '';

  virtualisation.oci-containers.containers."couchdb" = {
    image = "couchdb";
    autoStart = true;
    environmentFiles = [
      config.sops.templates."couchdb.env".path
    ];
    volumes = [
      "/mnt/tartaros/couchdb/data:/opt/couchdb/data"
      "/mnt/tartaros/couchdb/etc:/opt/couchdb/etc/local.d"
    ];
    ports = [
      "5984:5984"
    ];
  };
}
