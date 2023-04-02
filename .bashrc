
alias gs="git status"
alias gp="git pull"
alias push="git push"
alias commit="git commit -m"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias refresh="last_dir=$PWD && cd ~/configs && git pull && cd $last_dir"

export PATH="$PATH:~/bin"

alias exec="bash ~/configs/scripts/"

alias quit="exit"
alias t="turbo run"


bind -x '"\C-l": ls -alF'
bind -x '"\C-w": cd ~'
bind -x '"\C-d": pnpm dev'
bind -x '"\C-p": find-project'


function open-project() {
        echo $1;
}

function find-project() {
        echo -n "Find project: "; read project
        find ~/source -type d -name "*$project*" -maxdepth 3 -ok code {} \;
}
