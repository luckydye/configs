export CONFIGS_DIR=~/configs
export GPG_TTY=$(tty)
export PATH=~/bin:$PATH
export PATH=$CONFIGS_DIR/bin/bin:$PATH

# aliases
alias rel='source ~/.zshrc;'
alias ".."="cd .."
alias ll='ls -lah'
alias l='ls -CF'
alias quit="exit"
alias q="quit"
alias x="exit"
alias v='nvim'
alias f='spf .'
alias lg='lazygit'
alias files='yazi'
alias clip="pbcopy"
alias disk="diskonaut"
alias use="mise use"
alias pin="mise use --pin"
alias compose="docker compose"
alias u="tmux resize-pane -U 20"
alias clear="echo no clearing!"
alias gs="git status"
alias stash="git stash"
alias adda="git add --all"
alias pull="git pull"
alias fetch="git fetch"
alias gfp="git fetch --prune"
alias gcp="git cherry-pick"
alias rebase="git rebase"
alias push="git push"
alias P="git push"
alias time="~/bin/time"
alias disable_gpg="git config --local commit.gpgsign false"
alias enable_gpg="git config --local commit.gpgsign true"
alias "?"="~/source/qmark/target/debug/qmark"
alias claude="claude --dangerously-skip-permissions"

function addToPath() {
	export PATH=$1:$PATH
}

typeset -gA __taskfile_command_cache
typeset -gA __taskfile_command_cache_sig

function __find_taskfile() {
  local dir="$PWD"
  local file

  while [[ "$dir" != "/" ]]; do
    for file in Taskfile.yml Taskfile.yaml Taskfile.dist.yml Taskfile.dist.yaml taskfile.yml taskfile.yaml; do
      if [[ -f "$dir/$file" ]]; then
        print -r -- "$dir/$file"
        return 0
      fi
    done
    dir="${dir:h}"
  done

  return 1
}

function __taskfile_sig() {
  if [[ "$OSTYPE" == darwin* || "$OSTYPE" == freebsd* ]]; then
    command stat -f "%m:%z" "$1" 2>/dev/null
  else
    command stat -c "%Y:%s" "$1" 2>/dev/null
  fi
}

function __taskfile_has_command() {
  local command_name="$1"
  local taskfile="$2"
  local task_dir="${taskfile:h}"
  local sig="$(__taskfile_sig "$taskfile")"
  local output line task_name

  if [[ -z "$sig" ]]; then
    return 1
  fi

  if [[ "${__taskfile_command_cache_sig[$taskfile]}" != "$sig" ]]; then
    output="$(command task --dir "$task_dir" --taskfile "$taskfile" --list-all --sort none --color=false 2>/dev/null)" || return 1
    __taskfile_command_cache[$taskfile]=""

    for line in ${(f)output}; do
      if [[ "$line" =~ '^[[:space:]]*\*[[:space:]]+([^[:space:]]+):' ]]; then
        task_name="${match[1]}"
        __taskfile_command_cache[$taskfile]+="${task_name}"$'\n'
      fi
    done

    __taskfile_command_cache_sig[$taskfile]="$sig"
  fi

  for task_name in ${(f)__taskfile_command_cache[$taskfile]}; do
    [[ "$task_name" == "$command_name" ]] && return 0
  done

  return 1
}

function command_not_found_handler() {
  local command_name="$1"
  shift

  if command -v task >/dev/null 2>&1; then
    local taskfile="$(__find_taskfile)"

    if [[ -n "$taskfile" ]] && __taskfile_has_command "$command_name" "$taskfile"; then
      command task --dir "${taskfile:h}" --taskfile "$taskfile" "$command_name" -- "$@"
      return $?
    fi
  fi

  print -u2 "zsh: command not found: $command_name"
  return 127
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"

elif [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey "\033[H" beginning-of-line;
  bindkey "\033[F" end-of-line

elif grep -qi microsoft /proc/version 2> /dev/null; then
  # is wsl
  steam="/mnt/c/Program\ Files\ \(x86\)/Steam"

  # start csgo
  alias csgo="$steam/steam.exe -applaunch 730"
  alias csgo_config="cp ~/configs/apps/csgo/autoexec.cfg $steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/autoexec.cfg"
fi

eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
