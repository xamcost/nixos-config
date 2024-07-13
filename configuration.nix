# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
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
      allowedUDPPorts = [ 53 ];
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xamcost = {
    description = "xamcost";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpmgcxE7l/cgDR+MB4VYVdZDF6/Tb28wRx+pUlOn/c8 mbpro-2018-perso"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVO+qhlv/2/r2rXf1Kx9J2b2+fSC7mUu+B/ZqxM9lcS Maxime MacbookPro 2018"
    ];
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  programs.zsh.enable = true;

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
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    git
    inputs.nixpkgs.legacyPackages.${pkgs.system}.neovim
    pkgs.home-manager
  ];

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      xamcost = import ./home.nix;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
    #  http = {
    #    # You can select any ip and port, just make sure to open firewalls where needed
    #    address = "127.0.0.1:3003";
    #  };
    #  dns = {
    #    upstream_dns = [
    #      # Example config with quad9
    #      "9.9.9.9#dns.quad9.net"
    #      "149.112.112.112#dns.quad9.net"
    #      # Uncomment the following to use a local DNS service (e.g. Unbound)
    #      # Additionally replace the address & port as needed
    #      # "127.0.0.1:5335"
    #    ];
    #  };
    #  filtering = {
    #    protection_enabled = true;
    #    filtering_enabled = true;
    #    parental_enabled = false;  # Parental control-based DNS requests filtering.
    #    safe_search = {
    #      enabled = false;  # Enforcing "Safe search" option for search engines, when possible.
    #    };
    #  };
    #  # The following notation uses map
    #  # to not have to manually create {enabled = true; url = "";} for every filter
    #  # This is, however, fully optional
      filters = map(url: { enabled = true; url = url; }) [
        # "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
        # "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
