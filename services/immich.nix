# Auto-generated using compose2nix v0.2.1-pre.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  version = "v2.4.0";
  redis_version = "9@sha256:fb8d272e529ea567b9bf1302245796f21a2672b8368ca3fcb938ac334e613c8f";
  postgres_version = "14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
in
{
  sops.secrets.immich-postgres-password = { };

  sops.templates."immich.env".content = ''
    DB_DATABASE_NAME=immich
    DB_USERNAME=postgres
    DB_PASSWORD=${config.sops.placeholder.immich-postgres-password}
  '';
  sops.templates."immich_db.env".content = ''
    POSTGRES_DB=immich
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=${config.sops.placeholder.immich-postgres-password}
  '';

  # Containers
  virtualisation.oci-containers.containers."immich_server" = {
    image = "ghcr.io/immich-app/immich-server:${version}";
    environment = {
      TZ = "Europe/London";
    };
    environmentFiles = [ config.sops.templates."immich.env".path ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/mnt/tartaros/immich/app:/usr/src/app/upload:rw"
    ];
    ports = [ "2283:2283/tcp" ];
    dependsOn = [
      "immich_postgres"
      "immich_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich-server"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_server" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-immich_default.service" ];
    requires = [ "docker-network-immich_default.service" ];
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };
  virtualisation.oci-containers.containers."immich_machine_learning" = {
    image = "ghcr.io/immich-app/immich-machine-learning:${version}";
    environment = {
      TZ = "Europe/London";
    };
    environmentFiles = [ config.sops.templates."immich.env".path ];
    volumes = [ "immich_model-cache:/cache:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich-machine-learning"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_machine_learning" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-immich_default.service"
      "docker-volume-immich_model-cache.service"
    ];
    requires = [
      "docker-network-immich_default.service"
      "docker-volume-immich_model-cache.service"
    ];
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };
  virtualisation.oci-containers.containers."immich_postgres" = {
    image = "ghcr.io/immich-app/postgres:${postgres_version}";
    environment = {
      POSTGRES_INITDB_ARGS = "--data-checksums";
    };
    environmentFiles = [ config.sops.templates."immich_db.env".path ];
    volumes = [ "/mnt/tartaros/immich/postgres:/var/lib/postgresql/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=database"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-immich_default.service" ];
    requires = [ "docker-network-immich_default.service" ];
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };
  virtualisation.oci-containers.containers."immich_redis" = {
    image = "docker.io/valkey/valkey:${redis_version}";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=redis-cli ping || exit 1"
      "--network-alias=redis"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-immich_default.service" ];
    requires = [ "docker-network-immich_default.service" ];
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };

  # Networks
  systemd.services."docker-network-immich_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f immich_default";
    };
    script = ''
      docker network inspect immich_default || docker network create immich_default
    '';
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-immich_model-cache" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect immich_model-cache || docker volume create immich_model-cache
    '';
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-immich-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
