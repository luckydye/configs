bind -x '"\C-l": ls -alF'
bind -x '"\C-w": cd ~'
bind -x '"\C-d": npx skirp'
bind -x '"\C-p": find-project'

alias reload="source ~/.bashrc && update_configs"

if grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  source ${CONFIGS_DIR}/commands.sh
  source ${CONFIGS_DIR}/.wsl
else
  # native linux
  source ${CONFIGS_DIR}/commands.sh
fi
