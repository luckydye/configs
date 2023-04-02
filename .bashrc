bind -x '"\C-l": ls -alF'
bind -x '"\C-w": cd ~'
bind -x '"\C-d": pnpm dev'
bind -x '"\C-p": find-project'

alias reload="source ~/.bashrc"

source ~/configs/commands.sh

if grep -qi microsoft /proc/version; then
  source ~/configs/commands.sh
  source ~/configs/.wsl
else
  source ~/configs/commands.sh
fi
