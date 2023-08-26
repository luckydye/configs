source ${CONFIGS_DIR}/colors.sh

alias config='/usr/bin/git -C $HOME/configs/'
alias cfg='config'

alias rel="reload"
alias quit="exit"
alias x="exit"

# git
alias c="git checkout "
alias gs="git status"
alias gp="git pull"
alias adda="git add --all"
alias pull="git pull"
alias push="git push"
alias merge="git merge"

function commit() {
        msg="$*";
        git commit -m "$msg"
}

alias graph="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"

# docker
alias compose="docker-compose"
alias dd="docker run --rm -it --entrypoint "/source/devcontainer.sh" -v ~/source:/source -w /source luckydye/buildapp:latest"

# node
alias n="npm run"

# tasks
alias t="task"
alias use="rtx use"

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
        echo -e "\nChecking for config updates.."
        prev_dir=$PWD
        cd ${CONFIGS_DIR}
        echo -en git stash && git pull 2> /dev/null && git stash pop && echo -en "\n"
        cd $prev_dir
}

function play() {
        ansible-playbook ${CONFIGS_DIR}/playbooks/$1.yml
}

function addToPath() {
        echo "export PATH=$1:\$PATH" >> ~/.bashrc
}

function run() {
        SCRIPT_FILE=${CONFIGS_DIR}/scripts/$1
        find $SCRIPT_FILE 2> /dev/null && bash $SCRIPT_FILE $1 $2 $3 && return
        find $SCRIPT_FILE.sh 2> /dev/null && bash $SCRIPT_FILE.sh $1 $2 $3 && return
        find $SCRIPT_FILE.js 2> /dev/null && node $SCRIPT_FILE.js $1 $2 $3 && return
        find $SCRIPT_FILE.ts 2> /dev/null && bun $SCRIPT_FILE.ts $1 $2 $3 && return
}

function find-project() {
        # find all .git directories
        nvim $(find . -name .git -type d -maxdepth 4 | sed 's/\/.git//g' | gum filter)
}

function package_manager {
        which brew > /dev/null && { echo "brew"; return; }
        which yum > /dev/null && { echo "yum"; return; }
        which apk > /dev/null && { echo "apk"; return; }
        which apt > /dev/null && { echo "apt"; return; }
}

