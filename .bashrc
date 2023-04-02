# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"
alias gs="git status"
alias gp="git pull"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
. "$HOME/.cargo/env"
PATH=~/.console-ninja/.bin:$PATH

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


export PATH="$PATH:~/bin"


PROMPT='%F{blue}%1~%f ${vcs_info_msg_0_} ⚡ '

alias quit="exit"
alias t="turbo run"

bind -s '^l' 'clear; ls -l\n'
bind -s '^w' 'cd ~\n'
bind -s '^d' 'pnpm dev\n'
bind -s '^b' 'nvim ~/.zshrc\n'
bind -s '^p' 'find-project\n'

function open-project() {
        echo $1;
}

function find-project() {
        echo -n "Find project: "; read project
        find ~/source -type d -name "*$project*" -maxdepth 3 -ok code {} \;
}
