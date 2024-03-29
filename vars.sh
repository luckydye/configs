export CONFIGS_DIR=~/configs
export source=~/source

export PATH="$PATH:$HOME/bin"

export GPG_TTY=$(tty)

export MISE_INSTALL_PATH=~/bin/mise
export MISE_EXPERIMENTAL=true
export MISE_TRUSTED_CONFIG_PATHS=~/.config/mise/config.toml

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--height=100% --info=inline --preview-window="up,70%,border-horizontal"'

source $CONFIGS_DIR/env 2>/dev/null
