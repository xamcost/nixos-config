{
  virtualisation.oci-containers.containers."calibre-web-automated" = {
    image = "crocodilestick/calibre-web-automated:latest";
    autoStart = true;
    volumes = [
      "/mnt/tartaros/calibre/config:/config"
      "/mnt/tartaros/calibre/library:/calibre-library"
      "/mnt/tartaros/calibre/ingest:/cwa-book-ingest"
    ];
    environment = {
      TZ = "Europe/London";
      PUID = "1000";
      PGID = "1000";
    };
    ports = [
      "8083:8083/tcp"
    ];
  };
}
