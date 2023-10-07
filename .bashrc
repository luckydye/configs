source ~/configs/vars.sh

alias reload="source ~/.bashrc && clear"
alias fd='fdfind'

if grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  source ${CONFIGS_DIR}/commands.sh
  source ${CONFIGS_DIR}/.wsl
else
  # native linux
  source ${CONFIGS_DIR}/commands.sh
fi
