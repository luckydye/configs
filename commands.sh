# config util
alias config='cd $HOME/configs'
alias cfg='/usr/bin/git -C $HOME/configs/'
alias sync="mise run config_sync"
alias nuke="gum confirm 'Nuke configs?' && rm -rf ~/configs"

# navigation
alias ".."="cd .."
alias ll='ls -lah'
alias l='ls -CF'
alias ff='mise run find_file'
alias quit="exit"
alias q="quit"
alias x="exit"
alias s='cd $HOME/source'
alias fp='mise run find_project'
alias np='mise run create_project'
alias v='nvim'
alias z="~/source/zed/target/release/Zed ."
alias lg='lazygit'
alias files='watch -d ls -l'
alias clip="pbcopy"
alias k="mise run pass | clip"
alias disk="diskonaut"
alias pass="mise run pass"
alias otp="mise run otp"
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
alias r="mise run"
alias u="mise use"

function n() {
	script=$(task --list --json | jq -r ".tasks[].name" | gum filter)
	bun run $script
}

function t() {
	if [ $# -eq 0 ]; then
		name=$(task --list --json | jq -r ".tasks[].name" | gum filter)
  		task $name
	else
		task $1
	fi
}

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

bindkey -s '^p' ' run find_file\n'
bindkey -s '^x' ' run find_project\n'
bindkey -s '^l' ' run docker_attach\n'
bindkey -s '^f' ' run find_string\n'
bindkey -s '^g' ' run git_graph\n'
