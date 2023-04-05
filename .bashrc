bind -x '"\C-l": ls -alF'
bind -x '"\C-w": cd ~'
bind -x '"\C-d": pnpm dev'
bind -x '"\C-p": find-project'

alias reload="source ~/.bashrc"

if find /proc/version && grep -qi microsoft /proc/version; then
  # is wsl
  source ${CONFIGS_DIR}/commands.sh
  source ${CONFIGS_DIR}/.wsl
else
  # native linux
  source ${CONFIGS_DIR}/commands.sh
fi
