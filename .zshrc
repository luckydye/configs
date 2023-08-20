bindkey -s '^l' ' ls -l\n'
bindkey -s '^w' ' cd ~\n'
bindkey -s '^,' ' nvim ~/.zshrc\n'
bindkey -s '^p' ' find-project\n'

# select entry of command history
bindkey -s '^y' ' gum filter < ~/.zsh_history --height 40\n'

bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

alias reload="source ~/.zshrc && clear"

source ${CONFIGS_DIR}/commands.sh
