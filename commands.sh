alias gs="git status"
alias gp="git pull"
alias pull="git pull"
alias push="git push"
alias commit="git commit -m"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function update_configs() {
        echo "\tChecking for config updates.."
        prev_dir=$PWD
        cd ~/configs
        echo -n "\t" && git pull 2> /dev/null && echo "\n"
        cd $prev_dir
}

export PATH="$PATH:~/bin"

alias quit="exit"
alias t="turbo run"

function play() {
        ansible-playbook ~/configs/playbooks/$1
}

function run() {
        bash ~/configs/scripts/$1.sh
}

function find-project() {
        echo -n "Find project: "; read project
        find ~/source -type d -name "*$project*" -maxdepth 3 -ok code {} \;
}

function package_manager {
        which yum > /dev/null && { echo "yum"; return; }
        which apk > /dev/null && { echo "apk"; return; }
        which apt > /dev/null && { echo "apt"; return; }
}

# colors
RED='\033[0;31m'
CLEAR='\033[0m'

# motd
echo "\n\t${RED}luckydye/configs v2023${CLEAR}\n"

# autoupdate configs
update_configs
