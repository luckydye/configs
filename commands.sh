# config util
alias config='/usr/bin/git -C $HOME/configs/'
alias cfg='config'
alias rel="reload"
alias await="gum spin --show-output --spinner minidot"
# alias sync="await --title 'Syncing config with remote' -- bash ${CONFIGS_DIR}/scripts/config_sync.sh"
alias sync="bash ${CONFIGS_DIR}/scripts/config_sync.sh"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# navigation
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
alias ff='nvim $(fzf)'
alias quit="exit"
alias x="exit"
alias s='cd $HOME/source'
alias fp='run find_project'
alias repo='run open_git_repo'
alias v='nvim'

# tmux
alias ta="run tmux_attach"

# git
alias c="git checkout "
alias gs="git status"
alias gp="git pull"
alias adda="git add --all"
alias pull="git pull"
alias push="git push"
alias merge="git merge"
alias gd="git diff --cached ':!*lock'"

function commit() {
        msg="$*";
        git commit -m "$msg"
}

alias graph="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias g="graph"

# docker
alias compose="docker compose"
alias dd="docker run --rm -it --entrypoint "/source/devcontainer.sh" -v ~/source:/source -w /source luckydye/buildapp:latest"
alias datch="run docker_attach"
alias dshell="run docker_shell"

# node
alias n="npm run"

# tasks
alias t="task"
alias use="rtx use"


function play() {
        ansible-playbook ${CONFIGS_DIR}/playbooks/$1.yml
}

function addToPath() {
        echo "export PATH=$1:\$PATH" >> ~/.bashrc
        export PATH=$1:$PATH
}

function run() {
        [ -z "$1" ] && ls -1 ${CONFIGS_DIR}/scripts && return
        SCRIPT_FILE=${CONFIGS_DIR}/scripts/$1
        find $SCRIPT_FILE 2> /dev/null && bash $SCRIPT_FILE $2 $3 $4 && return
        find $SCRIPT_FILE.sh 2> /dev/null && bash $SCRIPT_FILE.sh $2 $3 $4 && return
        find $SCRIPT_FILE.js 2> /dev/null && node $SCRIPT_FILE.js $2 $3 $4 && return
        find $SCRIPT_FILE.ts 2> /dev/null && bun $SCRIPT_FILE.ts $2 $3 $4 && return
}

function package_manager {
        which brew > /dev/null && { echo "brew"; return; }
        which yum > /dev/null && { echo "yum"; return; }
        which apk > /dev/null && { echo "apk"; return; }
        which apt > /dev/null && { echo "apt"; return; }
}
