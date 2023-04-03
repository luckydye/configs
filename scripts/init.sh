# linux machine first setup

function package_manager {
  which yum > /dev/null && { echo "yum"; return; }
  which apk > /dev/null && { echo "apk"; return; }
  which apt > /dev/null && { echo "apt"; return; }
  which brew > /dev/null && { echo "brew"; return; }
}

if ! command -v git &> /dev/null
    pkgmngr=$(package_manager)

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
        exit
    fi
then

git clone https://github.com/luckydye/configs.git ~/configs

echo "source ~/configs/.bashrc" >> ~/.bashrc

echo "Successfully installed."
