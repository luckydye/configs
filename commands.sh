source ${CONFIGS_DIR}/colors.sh

alias quit="exit"

alias gs="git status"
alias gp="git pull"
alias add="git add"
alias adda="git add --all"
alias pull="git pull"
alias push="git push"
alias commit="git commit -m"

alias t="turbo run"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# homeassistant aliases
alias switch_on="run ha services/switch/turn_on"
alias switch_off="run ha services/switch/turn_off"
alias switch_toggle="run ha services/switch/toggle"

alias lamp="switch_toggle switch.lamp"
alias lamp2="switch_toggle switch.lamp_2"
alias pc_on="switch_on switch.speakers & switch_on switch.pc"
alias all_off="switch_off switch.lamp & switch_off switch.lamp_2 & switch_off switch.speakers & switch_off switch.pc"


function update_configs() {
        echo -e "\n\tChecking for config updates.."
        prev_dir=$PWD
        cd ${CONFIGS_DIR}
        echo -en "\t" && git stash && git pull 2> /dev/null && git stash pop && echo -en "\n"
        cd $prev_dir
        reload
}

export PATH="$PATH:~/bin"

function play() {
        ansible-playbook ${CONFIGS_DIR}/playbooks/$1.yml
}

function run() {
        SCRIPT_FILE=${CONFIGS_DIR}/scripts/$1
        find $SCRIPT_FILE 2> /dev/null && bash $SCRIPT_FILE $1 $2 $3 && return
        find $SCRIPT_FILE.sh 2> /dev/null && bash $SCRIPT_FILE.sh $1 $2 $3 && return
        find $SCRIPT_FILE.js 2> /dev/null && node $SCRIPT_FILE.js $1 $2 $3 && return
}

function find-project() {
        echo -en "Find project: "; read project
        find ~/source -type d -name "*$project*" -maxdepth 3 -ok code {} \;
}

function package_manager {
        which brew > /dev/null && { echo "brew"; return; }
        which yum > /dev/null && { echo "yum"; return; }
        which apk > /dev/null && { echo "apk"; return; }
        which apt > /dev/null && { echo "apt"; return; }
}

# motd
echo -e "\n\t${Red}luckydye/configs v2023${Clear}\n\t${CONFIGS_DIR}\n"

# autoupdate configs
#update_configs
