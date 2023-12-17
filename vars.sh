export CONFIGS_DIR=~/configs
export source=~/source

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:~/bin"

export GPG_TTY=$(tty)

export RTX_INSTALL_PATH=~/bin/rtx

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

export CHARM_HTTP_PORT=443
export CHARM_HOST=charm.luckydye.de

source $CONFIGS_DIR/env 2> /dev/null
