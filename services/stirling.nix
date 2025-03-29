{ config, ... }:
{
  sops.secrets = {
    "stirling/user" = {};
    "stirling/password" = {};
  };

  sops.templates."stirling.env".content = ''
    SERVER_PORT = 8088
    SECURITY_ENABLELOGIN = "true"
    SECURITY_CSRFDISABLED = "false"
    SECURITY_LOGINMETHOD = "normal"
    SECURITY_INITIALLOGIN_USERNAME = "${config.sops.placeholder."stirling/user"}"
    SECURITY_INITIALLOGIN_PASSWORD = "${config.sops.placeholder."stirling/password"}"
    SYSTEM_ENABLEANALYTICS = "false"
  '';

  services.stirling-pdf = {
    enable = true;
    environmentFiles = [
      config.sops.templates."stirling.env".path
    ];
  };
}
