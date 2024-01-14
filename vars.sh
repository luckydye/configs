export CONFIGS_DIR=~/configs
export source=~/source

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/share/mise/shims"

export GPG_TTY=$(tty)

export MISE_INSTALL_PATH=~/bin/mise
export MISE_EXPERIMENTAL=true

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

source $CONFIGS_DIR/env 2> /dev/null
