# install ansible and setup things

function package_manager {
  which brew > /dev/null && { echo "brew"; return; }
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
}

pkgmngr=$(package_manager)

case $pkgmngr in

  apt)
    sudo apt -y update
    sudo apt -y install ansible
    ansible-playbook ${CONFIGS_DIR}/playbooks/setup_ubuntu.yml
    ;;
    
  brew)
    brew install ansible
    ansible-playbook ${CONFIGS_DIR}/playbooks/setup_mac.yml
    ;;

  *)
    echo -n "unknown package manager"
    ;;
esac
