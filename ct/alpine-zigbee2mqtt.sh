#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Jonesckevin/proxmox_scripts/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/Jonesckevin/proxmox_scripts/raw/main/LICENSE
# Source: https://www.zigbee2mqtt.io/

APP="Alpine-Zigbee2MQTT"
var_tags="alpine;zigbee;mqtt;smarthome"
var_disk="0.3"
var_cpu=""
var_ram=""
var_os="alpine"
var_version="3.21"
var_unprivileged="0"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  if ! apk -e info newt >/dev/null 2>&1; then
    apk add -q newt
  fi
  while true; do
    CHOICE=$(
      whiptail --backtitle "Proxmox VE Helper Scripts" --title "SUPPORT" --menu "Select option" 11 58 1 \
        "1" "Check for Zigbee2MQTT Updates" 3>&2 2>&1 1>&3
    )
    exit_status=$?
    if [ $exit_status == 1 ]; then
      clear
      exit-script
    fi
    header_info
    case $CHOICE in
    1)
      apk update && apk upgrade
      exit
      ;;
    esac
  done
}

start
build_container
description

msg_ok "Completed Successfully!\n"