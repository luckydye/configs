# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="/usr/local/bin/python3:"$PATH

if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

alias ll="ls -l"
alias quit="exit"
alias t="turbo run"

bindkey -s '^l' ' ls -l\n'
bindkey -s '^w' ' cd ~\n'
bindkey -s '^d' ' pnpm dev\n'
bindkey -s '^b' ' nvim ~/.zshrc\n'
bindkey -s '^p' ' find-project\n'

function open-project() {
	echo $1;
}

function find-project() {
	echo -n "Find project: "; read project
	find ~/source -type d -name "*$project*" -maxdepth 3 -ok code {} \;
}

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

PROMPT='%F{blue}%1~%f ${vcs_info_msg_0_} ⚡ '

zstyle ':vcs_info:git:*' formats '%b'

export PATH=$PATH:/usr/local/Cellar/python@3.7/3.7.13_1/Frameworks/Python.framework/Versions/3.7/bin

export PATH=$PATH:~/Downloads/ffmpeg-build/workspace/bin      

export PATH=$PATH:/Users/tihav/miniconda/bin

bindkey "\033[H" beginning-of-line; bindkey "\033[F" end-of-line

export PATH="$PATH:/Users/tihav/bin"

# pnpm
export PNPM_HOME="/Users/tihav/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# bun completions
[ -s "/Users/tihav/.bun/_bun" ] && source "/Users/tihav/.bun/_bun"

# deno
export DENO_INSTALL="/Users/tihav/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

export PATH="/Users/tihav/Library/Caches/fnm_multishells/11038_1678450707207/bin":$PATH
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_LOGLEVEL="info"
export FNM_DIR="/Users/tihav/Library/Application Support/fnm"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_MULTISHELL_PATH="/Users/tihav/Library/Caches/fnm_multishells/11038_1678450707207"
export FNM_ARCH="arm64"
rehash
