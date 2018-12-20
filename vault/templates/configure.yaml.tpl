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
  - [ certbot, certonly, --server, "${acme_server}", -n, --agree-tos, --email, ${le_email}, --dns-route53, -d, ${vault_dns} ]
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
    storage "dynamodb" {
      ha_enabled = "true"
      region     = "${region}"
      table      = "${dynamodb_table_name}"
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
