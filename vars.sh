export CONFIGS_DIR=~/configs
export source=~/source

export PATH="$PATH:~/bin"

export CHARM_HTTP_PORT=443
export CHARM_HOST=charm.luckydye.de

export GPG_TTY=$(tty)

export OPENAI_API_KEY=$(skate get openai_token)
export HOME_ASSISTANT_TOKEN=$(skate get homeassistant_token)
