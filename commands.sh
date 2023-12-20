# config util
alias config='/usr/bin/git -C $HOME/configs/'
alias cfg='config'
alias rel="reload"
alias await="gum spin --show-output --spinner minidot"
alias sync="run config_sync"

# scratch
alias codellm='bun ~/source/llm/converters/src/main.ts'
alias mdllm='bun ~/source/llm/converters/src/markdown.ts'
alias llm='ollama run llama2'

alias toprores='FILE=$(gum file) ffmpeg -i $FILE -r 24 -pix_fmt yuv422p -c:v prores -c:a copy $FILE.mov'

# navigation
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ff='run find_file'
alias quit="exit"
alias x="exit"
alias s='cd $HOME/source'
alias fp='run find_project'
alias repo='run open_git_repo'
alias v='nvim'
alias lg='lazygit'
alias files='watch -d ls -l'

alias nuke="gum confirm 'Nuke configs?' && rm -rf ~/configs"

function addToPath() {
        echo "export PATH=$1:\$PATH" >> ~/.bashrc
        export PATH=$1:$PATH
}

function linkBin() {
        ln -s $1 ~/bin/
}

function toBin() {
        cp $1 ~/bin/
}

# tmux
alias ta="run tmux_attach"

# git
alias gs="git status"
alias adda="git add --all"
alias pull="git pull"
alias push="git push"
alias merge="git merge"
alias gd="git diff --stat --cached ':!*lock'"
alias graph="run git_graph"
alias g="graph"

function commit() {
    if [ $# -eq 0 ]
        then
            git commit -m "$(gum input --placeholder 'Commit message')"
    else
        msg="$*";
        git commit -m "$msg"
    fi
}

# https://gist.github.com/srsholmes/5607e26c187922878943c50edfb245ef
function grecent() {
    branches=$(git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]')
    branch=$(echo "$branches" | gum filter)
    git checkout $(echo "$branch" | tr -d "*" | awk '{print $1}')
}

function c() {
    if [ $# -eq 0 ]
      then
        grecent
    else
        git checkout $1
    fi
}

# docker
alias compose="docker compose"
alias dd="docker run --rm -it --entrypoint "/configs/devcontainer.sh" -v ~/source:/source -v ~/configs:/configs -w /source luckydye/buildapp:latest"
alias da="run docker_attach"
alias ds="run docker_shell"

# tasks
alias t="task"
alias u="rtx -g use"


# could use taskfie to defines these scripts in a declarative way. "task find_project" instead of "run find_proejct".
function run() {
    [ -z "$1" ] && ls -1 ${CONFIGS_DIR}/scripts && return
    SCRIPT_FILE=${CONFIGS_DIR}/scripts/$1
    find $SCRIPT_FILE > /dev/null 2>&1 && bash $SCRIPT_FILE $2 $3 $4 && return
    find $SCRIPT_FILE.sh > /dev/null 2>&1 && bash $SCRIPT_FILE.sh $2 $3 $4 && return
    find $SCRIPT_FILE.js > /dev/null 2>&1 && node $SCRIPT_FILE.js $2 $3 $4 && return
    find $SCRIPT_FILE.ts > /dev/null 2>&1 && bun $SCRIPT_FILE.ts $2 $3 $4 && return
    echo "script not found"
}

function package_manager {
    which brew > /dev/null && { echo "brew"; return; }
    which yum > /dev/null && { echo "yum"; return; }
    which apk > /dev/null && { echo "apk"; return; }
    which apt > /dev/null && { echo "apt"; return; }
}

function enc() {
    # TODO: encrypt/decrypt folders (tar to archive, encrypt archive. Then decrypt archive and deflate)
    openssl enc -aes-256-cbc -salt -pbkdf2 -in $1 -out $1.enc
}

function dec() {
    replace=".enc"
    replacewith=""
    out="${1/${replace}/${replacewith}}"
    openssl enc -d -aes-256-cbc -salt -pbkdf2 -in $1 -out $out
}

function calc() {
    echo "console.log(eval('$*'))" | node
}

eval "$(rtx activate)" 2> /dev/null
eval "$(starship init zsh)" 2> /dev/null
