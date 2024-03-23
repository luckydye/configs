source ~/configs/vars.sh

alias reload="source ~/.zshrc; clear"

# select entry of command history
bindkey -s '^h' ' gum filter < ~/.zsh_history --height 40\n'
bindkey -s '^p' ' run find_file\n'
bindkey -s '^x' ' run find_project\n'
bindkey -s '^l' ' run docker_attach\n'
bindkey -s '^f' ' run find_string\n'
bindkey -s '^g' ' run git_graph\n'

bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

if grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  source ${CONFIGS_DIR}/.wsl
fi

source ${CONFIGS_DIR}/commands.sh
