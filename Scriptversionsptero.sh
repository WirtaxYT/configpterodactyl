#!/bin/bash

set -e

########################################################
#
#         Pterodactyl-Script Downgrade
#
#         Created and maintained by Wirtax
#
#            Protected by MIT License
#
########################################################

GITHUB_STATUS_URL="https://www.githubstatus.com"
SCRIPT_VERSION="$(get_release)"

# Visual Functions #
print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}

hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}

YELLOW="\033[1;33m"
RESET="\e[0m"
RED='\033[0;31m'

error() {
  echo ""
  echo -e "* ${RED}ERROR${RESET}: $1"
  echo ""
}

# Check Sudo #
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# Check Git #
if [ -z "$SCRIPT_VERSION" ]; then
  error "Could not get the version of the script using GitHub."
  echo "* Please check on the site below if the 'API Requests' are as normal status."
  echo -e "${YELLOW}$(hyperlink "$GITHUB_STATUS_URL")${RESET}"
  exit 1
fi

# Check Curl #
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

cancel() {
echo
echo -e "* ${RED}Downgrade Canceled!${RESET}"
done=true
exit 1
}

done=false

echo
print_brake 70
echo "* Pterodactyl-downgrade Script @ $SCRIPT_VERSION"
echo
echo "* Copyright (C) 2021 - $(date +%Y), Wirtax."
echo
echo "* This script is not associated with the official Pterodactyl Project."
print_brake 70
echo

Backup() {
bash <(curl -s https://raw.githubusercontent.com/Ferks-FK/Pterodactyl-AutoThemes/"${SCRIPT_VERSION}"/backup.sh)
}

Downgrade 1.8.1() {
bash <(curl -s https://raw.githubusercontent.com/WirtaxYT/configpterodactyl/main/Downgrade%201-8-1.sh)
}

while [ "$done" == false ]; do
  options=(
    "Restore Panel Backup (Restore your panel if you have problems or want to remove themes)"
    "Downgrade 1.8.1"
    
    
    "Cancel Downgrade"
  )
  
  actions=(
    "Backup"
    "Downgrade 1.8.1"
    
    "cancel"
  )
  
  echo "* Which version do you want to install?"
  echo
  
  for i in "${!options[@]}"; do
    echo "[$i] ${options[$i]}"
  done
  
  echo
  echo -n "* Input 0-$((${#actions[@]} - 1)): "
  read -r action
  
  [ -z "$action" ] && error "Input is required" && continue
  
  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done
