# config util
alias config='cd $HOME/configs'
alias cfg='/usr/bin/git -C $HOME/configs/'
alias rel="reload"
alias sync="mise run config_sync"
alias nuke="gum confirm 'Nuke configs?' && rm -rf ~/configs"

# navigation
alias ".."="cd .."
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ff='mise run find_file'
alias quit="exit"
alias q="quit"
alias x="exit"
alias s='cd $HOME/source'
alias fp='mise run find_project'
alias v='nvim'
alias z="zed ."
alias lg='lazygit'
alias files='watch -d ls -l'
alias clip="pbcopy"
alias disk="diskonaut"
alias pass="mise run pass"
alias zed="~/source/zed/target/release/Zed"

# tmux
alias ta="mise run tmux_attach"

# git
alias gs="git status"
alias adda="git add --all"
alias pull="git pull"
alias fetch="git fetch --all"
alias push="git push"
alias P="git push"
alias gd="git diff --stat --cached ':!*lock'"
alias graph="git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias g="graph"
alias gg="watch --color -d \"git pull && git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --max-count=40\""

function merge() {
	if [ $# -eq 0 ]; then
		mise run git_merge
	else
		git checkout $1
	fi
}

function c() {
	if [ $# -eq 0 ]; then
		mise run git_checkout
	else
		git checkout $1
	fi
}

function commit() {
	if [ $# -eq 0 ]; then
		git commit -m "$(gum input --placeholder 'Commit message')"
	else
		msg="$*"
		git commit -m "$msg"
	fi
}

# docker
alias compose="docker compose"
alias dd="docker run --rm -it --entrypoint "/configs/devcontainer.sh" -v ~/source:/source -v ~/configs:/configs -w /source luckydye/buildapp:latest"
alias da="mise run docker_attach"
alias ds="mise run docker_shell"
alias dk="mise run docker_kill"

# tasks
alias t="task"
alias r="mise run"
alias u="mise use"

# mise task
function mt() {
	if [ $# -eq 0 ]; then
		mise task ls
	else
		msg="$*"
		mise run $msg
	fi
}

function run() {
	if [ $# -eq 0 ]; then
		mise run find_script
	else
		script="$*"
		mise run $script
	fi
}

function addToPath() {
	export PATH=$1:$PATH
}

function linkBin() {
	ln -s $1 ~/bin/
}

function toBin() {
	cp $1 ~/bin/
}

function package_manager {
	which brew >/dev/null && {
		echo "brew"
		return
	}
	which yum >/dev/null && {
		echo "yum"
		return
	}
	which apk >/dev/null && {
		echo "apk"
		return
	}
	which apt >/dev/null && {
		echo "apt"
		return
	}
}

function enc() {
	if [ ! -t 1 ]; then return; fi

	# TODO: encrypt/decrypt folders (tar to archive, encrypt archive. Then decrypt archive and deflate)
	openssl enc -aes-256-cbc -salt -pbkdf2 -in $1 -out $1.enc
}

function dec() {
	if [ ! -t 1 ]; then return; fi

	replace=".enc"
	replacewith=""
	out="${1/${replace}/${replacewith}}"
	openssl enc -d -aes-256-cbc -salt -pbkdf2 -in $1 -out $out
}

eval "$(mise activate)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
eval "$(zoxide init --cmd cd zsh)" 2>/dev/null
