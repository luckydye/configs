source ~/configs/vars.sh

alias reload="source ~/.zshrc; clear"

# select entry of command history
bindkey -s '^h' ' gum filter < ~/.zsh_history --height 40\n'
bindkey -s '^p' ' run find_file\n'
bindkey -s '^x' ' run find_project\n'
bindkey -s '^l' ' run docker_attach\n'
bindkey -s '^f' ' run find_string\n'
bindkey -s '^g' ' run git_graph\n'

pm=$(package_manager())

echo $pm

if grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  steam="/mnt/c/Program\ Files\ \(x86\)/Steam"

  # start csgo
  alias csgo="$steam/steam.exe -applaunch 730"
  alias csgo_config="cp $CONFIGS_DIR/apps/csgo/autoexec.cfg $steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/autoexec.cfg"
fi

if [ "$pm" == "apt" ]; then 
  alias pbcopy=’xclip -selection clipboard’
  alias pbpaste=’xclip -selection clipboard -o’
fi

if [ "$pm" == "brew" ]; then 
  bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line
fi

source ${CONFIGS_DIR}/commands.sh

eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
eval "$(zoxide init --cmd cd zsh)" 2>/dev/null
