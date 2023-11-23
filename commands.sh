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

# scratch
alias to_llm='fd --glob "**/*.ts" | ts_to_text | to_model'

# navigation
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
alias ff='nvim $(fzf)'
alias quit="exit"
alias x="exit"
alias s='cd $HOME/source'
alias fp='run find_project'
alias repo='run open_git_repo'
alias v='nvim'
alias lg='lazygit'

# tmux
alias ta="run tmux_attach"

# git
alias gs="git status"
alias adda="git add --all"
alias pull="git pull"
alias push="git push"
alias merge="git merge"
alias gd="git diff --cached ':!*lock'"

function commit() {
        msg="$*";
        git commit -m "$msg"
}

# https://gist.github.com/srsholmes/5607e26c187922878943c50edfb245ef
function grecent() {
    local branches branch
    branches=$(git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]')
    branch=$(echo "$branches" | gum filter)
    branch=$(echo "$branch" | awk '{print $1}' | tr -d "*")
    echo $branch
}

function c() {
    if [ $# -eq 0 ]
      then
        grecent
    else
        git checkout $0
    fi
}

alias graph="git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias g="graph"

# docker
alias compose="docker compose"
alias dd="docker run --rm -it --entrypoint "/configs/devcontainer.sh" -v ~/source:/source -v ~/configs:/configs -w /source luckydye/buildapp:latest"
alias da="run docker_attach"
alias ds="run docker_shell"

# node
alias n="npm run"

# tasks
alias t="task"
alias u="rtx use -g"


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

eval "$(rtx activate)" 2> /dev/null
