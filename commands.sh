source ${CONFIGS_DIR}/colors.sh

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
        cd ${CONFIGS_DIR}
        echo -n "\t" && git pull 2> /dev/null && echo -n "\n"
        cd $prev_dir
        reload
}

export PATH="$PATH:~/bin"

alias quit="exit"
alias t="turbo run"

function play() {
        ansible-playbook ${CONFIGS_DIR}/playbooks/$1.yml
}

function run() {
        SCRIPT_FILE=${CONFIGS_DIR}/scripts/$1
        find $SCRIPT_FILE 2> /dev/null && bash $SCRIPT_FILE && return
        find $SCRIPT_FILE.sh 2> /dev/null && bash $SCRIPT_FILE.sh && return
}

function find-project() {
        echo -n "Find project: "; read project
        find ~/source -type d -name "*$project*" -maxdepth 3 -ok code {} \;
}

function package_manager {
        which brew > /dev/null && { echo "brew"; return; }
        which yum > /dev/null && { echo "yum"; return; }
        which apk > /dev/null && { echo "apk"; return; }
        which apt > /dev/null && { echo "apt"; return; }
}

# motd
echo "\n\t${Red}luckydye/configs v2023${Clear}\n\t${CONFIGS_DIR}\n"

# autoupdate configs
#update_configs
