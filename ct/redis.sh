#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Jonesckevin/proxmox_scripts/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/Jonesckevin/proxmox_scripts/raw/main/LICENSE
# Source: https://redis.io/

APP="Redis"
var_tags="database"
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
    if [[ ! -f /lib/systemd/system/redis-server.service ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_error "Currently we don't provide an update function for this ${APP}."
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following IP:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}${IP}:6379${CL}"