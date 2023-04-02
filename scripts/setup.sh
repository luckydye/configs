# install ansible and setup things

function package_manager {
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
}

pkgmngr=$(package_manager)

case $pkgmngr in

  apt)
    sudo apt -y update
    sudo apt -y install ansible
    play setup_ubuntu.yml
    ;;

  *)
    echo -n "unknown package manager"
    ;;
esac
