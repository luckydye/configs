# aliases
alias rel='source ~/.zshrc;'
alias ".."="cd .."
alias ll='ls -lah'
alias l='ls -CF'
alias quit="exit"
alias q="quit"
alias x="exit"
alias v='nvim'
alias f='spf .'
alias lg='lazygit'
alias files='yazi'
alias t="task"
alias clip="pbcopy"
alias disk="diskonaut"
alias use="mise use"
alias pin="mise use --pin"
alias run="mise run"
alias u="tmux resize-pane -U 20"
alias clear="echo no clearing!"

function secure() {
 export RCLONE_CRYPT_PASSWORD=$(key get "storage - crypt")
}

# git
alias gs="git status"
alias gc="mise run gc"
alias stash="git stash"
alias adda="git add --all"
alias pull="git pull"
alias fetch="git fetch"
alias gfp="git fetch --prune"
alias gcp="git cherry-pick"
alias rebase="git rebase"
alias push="git push"
alias P="git push"
alias gd="git diff --stat --cached ':!*lock'"
alias g="git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%>(10,trunc) %C(bold yellow)%h%C(reset) %C(white)%s%C(reset)%C(auto)%d%C(reset) %C(dim white)- %an%C(reset) %C(bold dim white)(%cd)%C(reset) ' --all"
alias gg="watch --color -d \"git pull && git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --max-count=40\""

# docker
alias compose="docker compose"
alias da="mise run docker_attach"
alias dshell="mise run docker_shell"
alias dkill="mise run docker_kill"
alias drun='docker run -it --rm --name dev -w "/app" -v "./:/app" --platform linux/arm64 jdxcode/mise:latest'
alias dexec='docker exec -it -w "/app" dev'

function addToPath() {
	export PATH=$1:$PATH
}

function linkBin() {
	ln -s $1 ~/bin/
}
