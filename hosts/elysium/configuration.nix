{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
      ../../services/adguardhome.nix
      ../../services/borg.nix
      ../../services/calibre_web.nix
      ../../services/cloudflare_ddns.nix
      ../../services/freshrss.nix
      ../../services/grafana.nix
      ../../services/immich.nix
      ../../services/loki.nix
      ../../services/nextcloud.nix
      ../../services/postgresql.nix
      ../../services/prometheus.nix
      ../../services/traefik.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking = {
    networkmanager.enable = true;

    hostName = "elysium"; # Define your hostname.
    defaultGateway  = "192.168.1.254";
    nameservers  = [ "8.8.8.8" ];

    interfaces.eth0.ipv4.addresses = [ {
      address = "192.168.1.20";
      prefixLength = 24;
    } ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        22
	80
	443
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

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
    ];
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  security.sudo.extraRules = [
    {
      users = ["xamcost"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    pkgs.lazygit
    pkgs.home-manager
  ];

  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  powerManagement = {
    enable = true;
  };

  system.stateVersion = "24.05";

}
