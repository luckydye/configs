export CONFIGS_DIR=~/configs
export GPG_TTY=$(tty)

source ~/configs/commands.sh

addToPath ~/bin

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"

elif [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

  eval "$(zoxide init --cmd cd zsh)" 2>/dev/null

elif grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  steam="/mnt/c/Program\ Files\ \(x86\)/Steam"

  # start csgo
  alias csgo="$steam/steam.exe -applaunch 730"
  alias csgo_config="cp ~/configs/apps/csgo/autoexec.cfg $steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/autoexec.cfg"
fi

eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null

bindkey -s '^p' 'ff ^M'
bindkey -s '^x' 'fp ^M'
bindkey -s '^l' 'da ^M'
bindkey -s '^f' 'ff ^M'
bindkey -s '^g' 'g ^M'
