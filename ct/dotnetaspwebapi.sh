#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Jonesckevin/proxmox_scripts/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: Kristian Skov
# License: MIT | https://github.com/Jonesckevin/proxmox_scripts/raw/main/LICENSE
# Source: https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-9.0&tabs=linux-ubuntu

APP="Dotnet ASP Web API"
var_tags="web"
var_cpu=""
var_ram=""
var_disk="8"
var_os="ubuntu"
var_version="24.04"
var_unprivileged="0"

header_info "$APP"
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -d /var/www ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_info "Updating ${APP} LXC"
    $STD apt-get update
    $STD apt-get -y upgrade
    msg_ok "Updated Successfully"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following IP:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}${IP}:80${CL}"