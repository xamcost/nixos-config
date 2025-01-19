{
  virtualisation.oci-containers.containers."home_assistant" = {
    image = "lscr.io/linuxserver/homeassistant:latest";
    autoStart = true;
    volumes = [
      "/mnt/lethe/home_assistant:/config"
      "/etc/localtime:/etc/localtime:ro"
      "/var/run/dbus:/run/dbus:ro"  # For bluetooth
      "/home/hass/config/docker/run:/etc/services.d/home-assistant/run"
    ];
    environment = {
      TZ = "Europe/London";
      PUID = "1000";
      PGID = "100";
      UMASK = "022";
      DOCKER_MODS = "linuxserver/mods:homeassistant-hacs";
    };
    extraOptions = [
      "--pull=always" 
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_RAW"
      "--network=host"
    ];
  };
}
