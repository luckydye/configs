#!/usr/bin/env bash
# linux machine first setup

function explain() {
    echo ""
    echo "#######################################################"
    echo ""
    echo "Link skate to access enviroment secrets: run skate_link"
    echo "Installation complete. Open a new Terminal."
    echo ""
    echo "To sync config to the latest commit run: sync"
    echo ""
    echo "#######################################################"
    echo ""
}

function package_manager {
  which brew > /dev/null && { echo "brew"; return; }
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
}

pkgmngr=$(package_manager)

CONFIGS_DIR=~/configs
git clone https://github.com/luckydye/configs.git ${CONFIGS_DIR}

case $pkgmngr in

  brew)
    echo "# luckydye configs" >> ~/.zshrc
    echo "source $CONFIGS_DIR/.zshrc" >> ~/.zshrc
    source $CONFIGS_DIR/.zshrc
    ;;

  *)
    echo "# luckydye configs" >> ~/.bashrc
    echo "source $CONFIGS_DIR/.bashrc" >> ~/.bashrc
    source $CONFIGS_DIR/.bashrc
    ;;
esac

# After jetporch is published to package regestries, we dont need to install rust anymore.
# install rust and cargo
curl https://sh.rustup.rs -sSf | sh

# install jetporch
cargo install jetp

jetp local -p playbooks/setup.yml && explain
