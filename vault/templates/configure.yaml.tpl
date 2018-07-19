#cloud-config

packages:
  - 'certbot'
  - 'curl'
  - 'unzip'
  - 'python-pip'

users:
  - default
  - name: vault
    system: true

apt:
  sources:
    certbot:
      source: "ppa:certbot/certbot"

runcmd:
  - [ pip, install, certbot-dns-route53 ]
  - [ certbot, certonly, -n, --agree-tos, --email, letsencrypt@skyscrapers.eu, --dns-route53, -d, ${vault_dns} ]
  - [ chgrp, -R, vault, /etc/letsencrypt ]
  - [ chmod, -R, g=rX, /etc/letsencrypt ]
  - [ systemctl, enable, vault.service ]
  - [ systemctl, start, vault.service ]

write_files:
${teleport_config}
${teleport_service}
- content: |
    [Unit]
    Description=Vault server
    Requires=basic.target network.target
    After=basic.target network.target

    [Service]
    User=vault
    Group=vault
    PrivateDevices=yes
    PrivateTmp=yes
    ProtectSystem=full
    ProtectHome=read-only
    SecureBits=keep-caps
    Capabilities=CAP_IPC_LOCK+ep
    CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
    NoNewPrivileges=yes
    Environment=GOMAXPROCS=${vault_nproc}
    ExecStart=/usr/local/bin/vault server -config=/usr/local/etc/vault-config.json
    ExecReload=/bin/kill -SIGHUP $MAINPID
    KillSignal=SIGINT
    TimeoutStopSec=30s
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target

  path: /etc/systemd/system/vault.service
- content: |
    [Unit]
    Description=Let's Encrypt renewal

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/certbot renew --quiet --agree-tos --deploy-hook "chgrp -R vault /etc/letsencrypt && chmod -R g=rX /etc/letsencrypt && systemctl reload vault.service"
  path: /etc/systemd/system/certbot.service
- content: |
    [Unit]
    Description=Twice daily renewal of Let's Encrypt's certificates

    [Timer]
    OnCalendar=0/12:00:00
    RandomizedDelaySec=1h
    Persistent=true

    [Install]
    WantedBy=timers.target
  path: /etc/systemd/system/certbot.timer
- content: |
    storage "dynamodb" {
      ha_enabled = "true"
      region     = "eu-west-1"
      table      = "vault-dynamodb-backend"
    }

    listener "tcp" {
      address         = "0.0.0.0:8200"
      cluster_address = "0.0.0.0:8201"
      tls_cert_file   = "/etc/letsencrypt/live/${vault_dns}/fullchain.pem"
      tls_key_file    = "/etc/letsencrypt/live/${vault_dns}/privkey.pem"
    }

    api_addr      = "https://${vault_cluster_dns}"
    cluster_addr  = "https://${vault_dns}"
    disable_mlock = "true"
  path: /usr/local/etc/vault-config.json
