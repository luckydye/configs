export CONFIGS_DIR=~/configs
export source=~/source

export PATH="$PATH:$HOME/bin"

export GPG_TTY=$(tty)

export EDITOR=zed

export MISE_EXPERIMENTAL=true
export MISE_TRUSTED_CONFIG_PATHS=~$HOME/.config/mise/config.toml

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--height=100% --info=inline --preview-window="up,70%,border-horizontal"'

export GIT_LFS_SKIP_SMUDGE=1

source $CONFIGS_DIR/env 2>/dev/null
