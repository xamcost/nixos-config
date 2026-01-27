{ pkgs, ... }:
let
  interface = "eth0";
in
{
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    # Optimize network for use as exit node
    networkd-dispatcher = {
      enable = true;
      rules."50-tailscale" = {
        onState = [ "routable" ];
        script = ''
          ${pkgs.ethtool}/bin/ethtool -K ${interface} rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ethtool
    networkd-dispatcher
  ];
}
