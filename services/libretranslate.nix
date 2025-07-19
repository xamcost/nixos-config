{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ libretranslate ];

  systemd.services.libre-translate = {
    description = "Libretranslate server";
    serviceConfig = {
      ExecStart =
        "${pkgs.libretranslate}/bin/libretranslate --update-models --load-only en,fr,es,zh,ja,ko --port 5000";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.services.libre-translate.enable = true;
}
