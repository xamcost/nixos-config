{ config, ... }:
let port = 8089;
in {
  sops.secrets.shiori = { };

  services.shiori = {
    enable = true;
    address = "127.0.0.1";
    port = port;
    environmentFile = config.sops.secrets.shiori.path;
  };
}
