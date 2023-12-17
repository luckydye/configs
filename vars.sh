export CONFIGS_DIR=~/configs
export source=~/source

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:~/bin"

export GPG_TTY=$(tty)

export RTX_INSTALL_PATH=~/bin/rtx

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

source $CONFIGS_DIR/env 2> /dev/null
