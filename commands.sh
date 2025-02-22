# config util
alias rel="source ~/.zshrc; clear"
alias cfggit='/usr/bin/git -C $HOME/configs/'
alias cfg='task -t ~/configs/setup.yaml'
alias nuke="gum confirm 'Nuke configs?' && rm -rf $CONFIGS_DIR"

# navigation
alias ".."="cd .."
alias ll='ls -lah'
alias l='ls -CF'
alias ff='mise run find_file'
alias fs='mise run find_string'
alias quit="exit"
alias q="quit"
alias x="exit"
alias fp='mise run find_project'
alias new='mise run create_project'
alias v='nvim'
alias f='spf .'
alias lg='lazygit'
alias files='yazi'
alias t="task"
alias clip="pbcopy"
alias disk="diskonaut"
alias ta="mise run tmux_attach"
alias use="mise use"
alias pin="mise use --pin"
alias run="mise run"
alias u="tmux resize-pane -U 20"

# data transfer
alias vcs="ssh vcs"
alias backup='mise run backup'
alias backup_crypt='mise run backup_crypt'
alias upload='mise run upload'
alias sync="rclone sync --progress"
alias repos="mise run list_repos"

function secure() {
 export RCLONE_CRYPT_PASSWORD=$(key get "storage - crypt")
}

function toArchive() {
    YEAR=$(date +%Y)
    ARCHIVE_LOCATION=/mnt/pool2/share/tim/Media/footage/$YEAR/
    echo Uploading to $ARCHIVE_LOCATION
    rsync --filter=':- .gitignore' --progress -rtuvz -e 'ssh -p 9002' $1 archive:$ARCHIVE_LOCATION
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

function mr() {
	git push -o merge_request.create -o merge_request.assign="$(git config user.name)" -o merge_request.title="$1"
}

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
