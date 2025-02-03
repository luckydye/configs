# config util
alias cfg='/usr/bin/git -C $HOME/configs/'
alias nuke="gum confirm 'Nuke configs?' && rm -rf $CONFIGS_DIR"

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
alias new='mise run create_project'
alias v='nvim'
alias z="~/source/zed/target/release/Zed ."
alias lg='lazygit'
alias files='yazi'
alias f='spf .'
alias vcs="ssh vcs"
alias t="task"
alias backup='mise run backup'
alias backup_enc='mise run backup_enc'
alias sync="rclone sync --progress"

# TODO: make a "migrate" command to send files like ssh keys and env vars over p2p securely to another machein

# git
alias gs="git status"
alias stash="git stash"
alias adda="git add --all"
alias pull="git pull"
alias fetch="git fetch"
alias gfp="git fetch --prune"
alias gp="git cherry-pick"
alias rebase="git rebase"
alias push="git push"
alias P="git push"
alias gd="git diff --stat --cached ':!*lock'"
alias graph="git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%>(10,trunc) %C(bold yellow)%h%C(reset) %C(white)%s%C(reset)%C(auto)%d%C(reset) %C(dim white)- %an%C(reset) %C(bold dim white)(%cd)%C(reset) ' --all"
alias g="graph"
alias gg="watch --color -d \"git pull && git log --graph --author-date-order --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --max-count=40\""

function clone() {
	cd ~/source

	repo="$*"
	git clone $repo

	id="$HOME/source/$(basename -s .git $repo)"
	cd $id

	tmux new-session -d -s $id

	if [ -z "$TMUX" ]; then
		tmux attach -t $id
	else
		tmux switch-client -t $id
	fi
}

# docker
alias compose="docker compose"
alias dd="docker run --rm -it --entrypoint "/configs/devcontainer.sh" -v ~/source:/source -v $CONFIGS_DIR:/configs -w /source luckydye/buildapp:latest"
alias da="mise run docker_attach"
alias ds="mise run docker_shell"
alias dk="mise run docker_kill"
alias drun='docker run -it --rm --name dev -w "/app" -v "./:/app" --platform linux/amd64'
alias dexec='docker exec -it -w "/app" dev'

# misc
alias clip="pbcopy"
alias disk="diskonaut"
alias ta="mise run tmux_attach"
alias use="mise use"
alias run="mise run"
alias s3="mise run s3"

function n() {
	script=$(task --list --json | jq -r ".tasks[].name" | gum filter)
	bun run $script
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

function toArchive() {
    YEAR=$(date +%Y)
    ARCHIVE_LOCATION=/mnt/pool2/share/tim/Media/footage/$YEAR/
    echo Uploading to $ARCHIVE_LOCATION
    rsync --filter=':- .gitignore' --progress -rtuvz -e 'ssh -p 9002' $1 $ARCHIVE_USER@localhost:$ARCHIVE_LOCATION
}

function secure() {
 PASS=$(key get "storage - crypt")
 alias sync="rclone sync --crypt-password=$PASS"
}

function enc() {
	if [ ! -t 1 ]; then return; fi

	# TODO: encrypt/decrypt folders (tar to archive, encrypt archive. Then decrypt archive and deflate)
	openssl enc -aes-256-cbc -salt -pbkdf2 -in $1 -out $1.enc $2
}

function dec() {
	if [ ! -t 1 ]; then return; fi

	replace=".enc"
	replacewith=""
	out="${1/${replace}/${replacewith}}"
	openssl enc -d -aes-256-cbc -salt -pbkdf2 -in $1 -out $out $2
}

bindkey -s '^p' 'ff ^M'
bindkey -s '^x' 'fp ^M'
bindkey -s '^l' 'da ^M'
bindkey -s '^f' 'ff ^M'
bindkey -s '^g' 'g ^M'
