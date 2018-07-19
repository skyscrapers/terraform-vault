#!/usr/bin/env bash
set -e

# Time before the kernel kills a connection in CLOSE_WAIT
# reduced to 5 minutes as Vault keeps a lot of connections
echo 'net.ipv4.tcp_keepalive_time = 300' >> /etc/sysctl.conf
sysctl -p

cd /tmp

curl -L "${download_url_vault}" > /tmp/vault.zip

sudo unzip vault.zip
sudo mv vault /usr/local/bin
sudo chmod 0755 /usr/local/bin/vault
sudo chown root:root /usr/local/bin/vault

if [ -n "${teleport_auth_server}" ]; then
  curl -L "${download_url_teleport}" > /tmp/teleport.tar.gz

  sudo tar -xzf teleport.tar.gz
  sudo /tmp/teleport/install
fi

sudo systemctl daemon-reload
