alias gs="git status"
alias gp="git pull"
alias push="git push"
alias commit="git commit -m"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias update_configs="last_dir=$PWD && cd ~/configs && git pull && cd $last_dir"

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
