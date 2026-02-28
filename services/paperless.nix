{ config, ... }:
{
  sops = {
    secrets = {
      "paperless-password" = {
        owner = "paperless";
      };
    };

    templates."paperless.env" = {
      content = ''
        PAPERLESS_URL="https://paperless.${config.sops.placeholder.domain}"
      '';
      owner = "paperless";
    };
  };

  # Prevents running tests during build, which takes a long time.
  nixpkgs.overlays = [
    (self: super: {
      paperless-ngx = super.paperless-ngx.overrideAttrs (oldAttrs: {
        doCheck = false;
        doInstallCheck = false;
        dontCheck = true;
      });
    })
  ];

  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."paperless-password".path;
    environmentFile = config.sops.templates."paperless.env".path;
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "eng+fra+spa";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
    dataDir = "/mnt/tartaros/paperless";
  };
}
