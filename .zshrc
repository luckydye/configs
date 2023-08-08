bindkey -s '^l' ' ls -l\n'
bindkey -s '^w' ' cd ~\n'
bindkey -s '^d' ' npx skirp\n'
bindkey -s '^b' ' nvim ~/.zshrc\n'
bindkey -s '^p' ' find-project\n'
bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

alias reload="source ~/.zshrc"

function volume() {
  osascript -e "set Volume $1"
}

export GPG_TTY=$(tty)

source ${CONFIGS_DIR}/commands.sh
