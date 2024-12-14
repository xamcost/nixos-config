{ inputs,config, pkgs, ... }:
let
  user = "xam";
  hostname = "aeneas";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
      ../common
      ../../services/tailscale.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking = {
    hostName = hostname;
  };

  # Sops secrets management
  sops.age.keyFile = "/home/xam/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.secrets.password = {
    neededForUsers = true;
    sopsFile = ./secrets.yaml;
    format = "yaml";
  };

  users = {
    mutableUsers = false;
    users."${user}" = {
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
  };

  security.sudo.extraRules = [
    {
      users = ["${user}"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
