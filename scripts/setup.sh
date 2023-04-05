#!/usr/bin/env bash
# install ansible and setup things

function package_manager {
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
  which brew > /dev/null && { echo "brew"; return; }
}

pkgmngr=$(package_manager)

case $pkgmngr in

  apt)
    sudo apt -y update
    sudo apt -y install ansible
    ansible-playbook ~/configs/playbooks/setup_ubuntu.yml
    ;;
    
  brwe)
    brwe install ansible
    ansible-playbook ~/configs/playbooks/setup_ubuntu.yml
    ;;

  *)
    echo -n "unknown package manager"
    ;;
esac
