source ~/configs/vars.sh
source ${CONFIGS_DIR}/commands.sh

alias rel="source ~/.zshrc; clear"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias pbcopy=’xclip -selection clipboard’
  alias pbpaste=’xclip -selection clipboard -o’

elif [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

  eval "$(zoxide init --cmd cd zsh)" 2>/dev/null

elif grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  steam="/mnt/c/Program\ Files\ \(x86\)/Steam"

  # start csgo
  alias csgo="$steam/steam.exe -applaunch 730"
  alias csgo_config="cp $CONFIGS_DIR/apps/csgo/autoexec.cfg $steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/autoexec.cfg"
fi


eval "$(mise env)" 2>/dev/null

eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
