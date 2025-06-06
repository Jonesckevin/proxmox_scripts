#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/Jonesckevin/proxmox_scripts/raw/main/LICENSE
# Source: https://gethomepage.dev/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y gpg
msg_ok "Installed Dependencies"

msg_info "Setting up Node.js Repository"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" >/etc/apt/sources.list.d/nodesource.list
msg_ok "Set up Node.js Repository"

msg_info "Installing Node.js"
$STD apt-get update
$STD apt-get install -y nodejs
$STD npm install -g pnpm
msg_ok "Installed Node.js"

LOCAL_IP=$(hostname -I | awk '{print $1}')
RELEASE=$(curl -fsSL https://api.github.com/repos/gethomepage/homepage/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
msg_info "Installing Homepage v${RELEASE} (Patience)"
curl -fsSL "https://github.com/gethomepage/homepage/archive/refs/tags/v${RELEASE}.tar.gz" -o $(basename "https://github.com/gethomepage/homepage/archive/refs/tags/v${RELEASE}.tar.gz")
$STD tar -xzf v${RELEASE}.tar.gz
rm -rf v${RELEASE}.tar.gz
mkdir -p /opt/homepage/config
mv homepage-${RELEASE}/* /opt/homepage
rm -rf homepage-${RELEASE}
cd /opt/homepage
cp /opt/homepage/src/skeleton/* /opt/homepage/config
$STD pnpm install
export NEXT_PUBLIC_VERSION="v$RELEASE"
export NEXT_PUBLIC_REVISION="source"
export NEXT_TELEMETRY_DISABLED=1
$STD pnpm build
echo "HOMEPAGE_ALLOWED_HOSTS=localhost:3000,${LOCAL_IP}:3000" >/opt/homepage/.env
echo "${RELEASE}" >/opt/${APPLICATION}_version.txt
msg_ok "Installed Homepage v${RELEASE}"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/homepage.service
[Unit]
Description=Homepage
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
WorkingDirectory=/opt/homepage/
ExecStart=pnpm start
[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now homepage
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
