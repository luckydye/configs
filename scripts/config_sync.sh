#!/bin/bash

git -C $HOME/configs/ stash
git -C $HOME/configs/ pull
git -C $HOME/configs/ stash pop

function package_manager {
  which brew > /dev/null && { echo "brew"; return; }
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
}

case $(package_manager) in
  apt)
    ansible-playbook $CONFIGS_DIR/playbooks/setup_ubuntu.yml || exit 1
    ;;

  brew)
    ansible-playbook $CONFIGS_DIR/playbooks/setup_mac.yml || exit 1
    ;;

  *)
    echo -n "unknown package manager"
    ;;
esac

sleep 0.5

git -C $HOME/configs/ add --all
git -C $HOME/configs/ commit -m "sync config"
git -C $HOME/configs/ push
