export CONFIGS_DIR=~/configs
export GPG_TTY=$(tty)
export PATH=~/bin:$PATH
export PATH=$CONFIGS_DIR/bin/bin:$PATH

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
alias clip="pbcopy"
alias disk="diskonaut"
alias use="mise use"
alias pin="mise use --pin"
alias compose="docker compose"
alias u="tmux resize-pane -U 20"
alias clear="echo no clearing!"
alias gs="git status"
alias stash="git stash"
alias adda="git add --all"
alias pull="git pull"
alias fetch="git fetch"
alias gfp="git fetch --prune"
alias gcp="git cherry-pick"
alias rebase="git rebase"
alias push="git push"
alias P="git push"
alias time="~/bin/time"

function addToPath() {
	export PATH=$1:$PATH
}

function linkBin() {
	ln -s $1 ~/bin/
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"

elif [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey "\033[H" beginning-of-line;
  bindkey "\033[F" end-of-line

elif grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  steam="/mnt/c/Program\ Files\ \(x86\)/Steam"

  # start csgo
  alias csgo="$steam/steam.exe -applaunch 730"
  alias csgo_config="cp ~/configs/apps/csgo/autoexec.cfg $steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/autoexec.cfg"
fi

eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
