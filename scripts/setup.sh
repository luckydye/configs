# install ansible and setup things

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
