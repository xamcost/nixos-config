{
  virtualisation.oci-containers.containers."home_assistant" = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    autoStart = true;
    volumes = [
      "/home/xamcost/documents/home_assistant:/config"
      "/etc/localtime:/etc/localtime:ro"
      "/var/run/dbus:/run/dbus:ro"  # For bluetooth
    ];
    environment = {
      TZ = "Europe/London";
    };
    extraOptions = [
      "--network=host"
    ];
  };
}
