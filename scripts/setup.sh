# install ansible and setup things

case $(package_manager) in

  apt)
    sudo apt -y update
    sudo apt -y install ansible
    play setup_ubuntu
    ;;
    
  brew)
    brew install ansible
    play setup_mac
    ;;

  *)
    echo -n "unknown package manager"
    ;;
esac
