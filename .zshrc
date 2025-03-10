export CONFIGS_DIR=~/configs
export GPG_TTY=$(tty)
export PATH=~/bin:$PATH

source ~/configs/commands.sh

eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
