{ config, pkgs, ... }:
{
  sops.secrets.domain = { };
  sops.secrets."navidrome/password-encryption-key" = { };
  sops.secrets."navidrome/lastfm-api-key" = { };
  sops.secrets."navidrome/lastfm-secret" = { };

  sops.templates."navidrome.env".content = ''
    ND_BASEURL=https://navidrome.${config.sops.placeholder.domain}
    ND_DEEZER_ENABLED=true
    ND_LASTFM_ENABLED=true
    ND_LASTFM_APIKEY=${config.sops.placeholder."navidrome/lastfm-api-key"}
    ND_LASTFM_SECRET=${config.sops.placeholder."navidrome/lastfm-secret"}
    ND_PASSWORDENCRYPTIONKEY=${config.sops.placeholder."navidrome/password-encryption-key"}
  '';

  # Temporary fix: https://github.com/NixOS/nixpkgs/issues/481611#issuecomment-3890134071
  # nixpkgs.overlays = [
  #   (self: super: {
  #     navidrome = self.callPackage (pkgs.fetchurl {
  #       url = "https://raw.githubusercontent.com/cimm/nixpkgs/71aa374ad541b41e6fccd543c67b6952d2ccafca/pkgs/by-name/na/navidrome/package.nix";
  #       sha256 = "16mfj85w8d7vzc9pgcgjn7a71z7jywqpdn8igk9zp0hw9dvm9rmq";
  #     }) { };
  #   })
  # ];

  services.navidrome = {
    enable = true;
    environmentFile = config.sops.templates."navidrome.env".path;
    settings = {
      EnableInsightsCollector = false;
      MusicFolder = "/mnt/lethe/music";
      DataFolder = "/mnt/tartaros/navidrome/data";
      Agents = "lastfm,spotify,deezer";
    };
  };
}
