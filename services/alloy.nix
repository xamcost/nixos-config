{ config, ... }:
{
  users.groups.alloy = { };
  users.users.alloy = {
    isSystemUser = true;
    group = "alloy";
  };

  sops.secrets.aeneas-ip = { };
  sops.templates."config.alloy" = {
    content = ''
      // Source for systemd journal logs
      loki.source.journal "elysium" {
        path          = "/var/log/journal"
        max_age       = "12h"
        relabel_rules = loki.relabel.journal.rules
        labels        = { job = "systemd-journal" }
        forward_to    = [loki.process.journal.receiver]
      }

      // Collector for systemd journal logs, with some basic filtering to reduce noise and volume
      loki.process "journal" {
        // Drop high-volume units that rarely carry actionable signal in a
        // generic dev/ops dashboard. Tune this list to your environment.
        stage.match {
          selector = `{unit=~"systemd-logind.service|systemd-tmpfiles-clean.service|cron.service"}`
          action   = "drop"
        }

        // Drop low-priority entries (info / debug). Keep notice and above.
        // Adjust if you want to keep info messages.
        stage.match {
          selector = `{priority=~"info|debug"}`
          action   = "drop"
        }

        forward_to = [loki.write.local.receiver]
      }

      // Processor for systemd journal logs
      loki.relabel "journal" {
        forward_to = []

        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }

        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "priority"
        }

        rule {
          source_labels = ["__journal__hostname"]
          target_label  = "elysium"
        }
      }

      // Set up destination for logs
      loki.write "local" {
        endpoint {
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push"
        }
      }
    '';
    owner = "alloy";
  };

  services.alloy = {
    enable = true;
    configPath = config.sops.templates."config.alloy".path;
  };

  systemd.services.alloy = {
    serviceConfig.User = "alloy";
  };
}
