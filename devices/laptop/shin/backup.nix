# {
#   config,
#   lib,
#   pkgs,
#   ...
# }:
# {
#   services.borgbackup.jobs.prometheus-home = {
#     paths = "/home/shin";
#     exclude = [
#       "/home/shin/.cache"
#       "/home/shin/.nix-defexpr"
#       "/home/shin/.nix-profile"
#       "/home/shin/.mozilla"
#       "/home/shin/.pki"
#       "/home/shin/.steam"
#       "/home/shin/.terraform.d"
#       "/home/shin/.var"
#     ];
#     encryption.mode = "repokey";
#     encryption.passCommand = "cat /run/agenix/borg.prometheus.age";
#     environment.BORG_RSH = "ssh -i /home/shin/.ssh/borg";
#     repo = "ssh://borg@100.106.154.7:22/mnt/backups/thinkpad_new";
#     compression = "auto,zstd";
#     prune.keep = {
#       daily = 7;
#       weekly = 4;
#       monthly = 3;
#     };
#     startAt = [ ];
#   };
#
#   age.secrets."borg.prometheus.age" = {
#     file = ../../../secrets/borg.prometheus.age;
#     path = "/run/agenix/borg.prometheus.age";
#     owner = "shin";
#     group = "users";
#     mode = "0400";
#   };
# }
