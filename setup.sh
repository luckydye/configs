#!/usr/bin/env bash
# linux machine first setup

function package_manager {
  which brew > /dev/null && { echo "brew"; return; }
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
}

pkgmngr=$(package_manager)

if ! command -v git &> /dev/null
then
    case $pkgmngr in

      apt)
        sudo apt -y update
        sudo apt -y install git
        ;;

      brew)
        brew install git
        ;;

      *)
        echo -n "unknown package manager"
        ;;
    esac
fi

CONFIGS_DIR=~/configs
git clone https://github.com/luckydye/configs.git ${CONFIGS_DIR}

case $pkgmngr in

  brew)
    echo "# luckydye configs" >> ~/.zshrc
    echo "source $CONFIGS_DIR/vars.sh" >> ~/.zshrc
    echo "source $CONFIGS_DIR/.zshrc" >> ~/.zshrc
    ;;

  *)
    ;;
esac

echo "# luckydye configs" >> ~/.bashrc
echo "source $CONFIGS_DIR/vars.sh" >> ~/.bashrc
echo "source $CONFIGS_DIR/.bashrc" >> ~/.bashrc

case $pkgmngr in

  apt)
    sudo apt -y update
    sudo apt -y install ansible
    pip install ansible
    ansible-playbook $CONFIGS_DIR/playbooks/setup_ubuntu.yml
    ;;
    
  brew)
    brew install ansible
    pip install ansible
    ansible-playbook $CONFIGS_DIR/playbooks/setup_mac.yml
    ;;

  *)
    echo -n "unknown package manager"
    ;;
esac

echo "Installation complete. Open a new Terminal."
