{
  virtualisation.oci-containers.containers."signal" = {
    image = "bbernhard/signal-cli-rest-api:latest";
    autoStart = true;
    volumes =
      [ "/var/run/signal/signal-cli-config:/home/.local/share/signal-cli" ];
    environment = { MODE = "normal"; };
    ports = [ "8091:8080" ];
  };
}
