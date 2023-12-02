source ~/configs/vars.sh

alias reload="source ~/.zshrc && clear"

# select entry of command history
bindkey -s '^h' ' gum filter < ~/.zsh_history --height 40\n'
bindkey -s '^p' ' ff\n'
bindkey -s '^r' ' fp\n'
bindkey -s '^g' ' graph\n'

bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

source ${CONFIGS_DIR}/commands.sh

