#!/bin/bash
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
        brwe install git
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
    echo "source $CONFIGS_DIR/vars.sh" >> ~/.zshrc
    echo "source $CONFIGS_DIR/$RC_FILE_NAME" >> ~/.zshrc
    ;;

  *)
    ;;
esac

echo "source $CONFIGS_DIR/vars.sh" >> ~/.bashrc
echo "source $CONFIGS_DIR/$RC_FILE_NAME" >> ~/.bashrc

echo "Successfully installed. Open a new Terminal."
