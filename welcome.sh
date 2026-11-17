#!/bin/bash
cat << 'EOF'

 [1;35m╔══════════════════════════════════════════════════════════════════════╗ [0m
 [1;35m║ [0m   [1;32mDebian Linux Cloud Environment (Google Antigravity AI Engine) [0m       [1;35m║ [0m
 [1;35m╠══════════════════════════════════════════════════════════════════════╣ [0m
 [1;35m║ [0m   [1;33m* OS: [0m Debian 12 (Bookworm) x86_64                                  [1;35m║ [0m
 [1;35m║ [0m   [1;33m* systemctl: [0m Enabled & ready (docker-systemctl-replacement)        [1;35m║ [0m
 [1;35m║ [0m   [1;33m* Web Terminal: [0m Running via ttyd                                   [1;35m║ [0m
 [1;35m║ [0m   [1;33m* Working Directory: [0m /workspace                                     [1;35m║ [0m
 [1;35m║ [0m   [1;33m* Persistent Data: [0m   /data                                          [1;35m║ [0m
 [1;35m╠══════════════════════════════════════════════════════════════════════╣ [0m
 [1;35m║ [0m   [1;36m[Google Antigravity CLI & Remote Control] [0m                          [1;35m║ [0m
 [1;35m║ [0m  To interact with the CLI:                                            [1;35m║ [0m
 [1;35m║ [0m       [1;37magy [0m                                                          [1;35m║ [0m
 [1;35m║ [0m  To launch the Remote Control daemon:                                 [1;35m║ [0m
 [1;35m║ [0m       [1;37magy-remote-control-start [0m                                        [1;35m║ [0m
 [1;35m║ [0m  or manage it as a systemd service:                                  [1;35m║ [0m
 [1;35m║ [0m       [1;37msystemctl start agy-remote-control [0m                              [1;35m║ [0m
 [1;35m║ [0m       [1;37msystemctl status agy-remote-control [0m                             [1;35m║ [0m
 [1;35m╚══════════════════════════════════════════════════════════════════════╝ [0m

EOF
