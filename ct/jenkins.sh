#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Jonesckevin/proxmox_scripts/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: kristocopani
# License: MIT | https://github.com/Jonesckevin/proxmox_scripts/raw/main/LICENSE
# Source: https://www.jenkins.io/

APP="Jenkins"
var_tags="automation"
var_cpu=""
var_ram=""
var_disk="4"
var_os="debian"
var_version="12"
var_unprivileged="1"

header_info "$APP"
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -d /var/lib/jenkins ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_info "Updating $APP LXC"
    $STD apt-get update
    $STD apt-get -y upgrade
    msg_ok "Updated $APP LXC"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8080${CL}"