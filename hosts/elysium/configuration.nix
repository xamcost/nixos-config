{ config, pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    ../common-nixos
    ../common
    ../../services/adguardhome.nix
    ../../services/borg.nix
    ../../services/calibre_web.nix
    ../../services/cloudflare_ddns.nix
    ../../services/couchdb.nix
    ../../services/glance.nix
    ../../services/grafana.nix
    ../../services/home_assistant.nix
    ../../services/immich.nix
    ../../services/influxdb.nix
    ../../services/jellyfin.nix
    ../../services/languagetool.nix
    ../../services/loki.nix
    ../../services/mosquitto.nix
    ../../services/nextcloud.nix
    ../../services/paperless.nix
    ../../services/postgresql.nix
    ../../services/prometheus.nix
    ../../services/shiori.nix
    ../../services/stirling.nix
    ../../services/tailscale.nix
    ../../services/traefik.nix
    ../../services/zigbee2mqtt.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking = {
    hostName = "elysium"; # Define your hostname.
    defaultGateway = "192.168.1.254";
    nameservers = [ "8.8.8.8" ];

    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.1.20";
      prefixLength = 24;
    }];

    firewall = {
      allowedTCPPorts = [
        80
        443
        1883 # MQTT
        8099 # zigbee2mqtt
        8123 # Home Assistant
      ];
      allowedUDPPorts = [ 53 ];
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Docker runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Sops secrets management
  sops.age.keyFile = "/home/xamcost/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.secrets.password = {
    neededForUsers = true;
    sopsFile = ./secrets.yaml;
    format = "yaml";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xamcost = {
    description = "xamcost";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpmgcxE7l/cgDR+MB4VYVdZDF6/Tb28wRx+pUlOn/c8 mbpro-2018-perso"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVO+qhlv/2/r2rXf1Kx9J2b2+fSC7mUu+B/ZqxM9lcS Maxime MacbookPro 2018"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSRh4x8VvzVBOcJwOQdP/0r+k+C3cY7cvWaytDYOv3U Xam MBProM4"
    ];
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  security.sudo.extraRules = [{
    users = [ "xamcost" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  powerManagement = { enable = true; };

  system.stateVersion = "24.05";

}
