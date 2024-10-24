# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# NOTE: Setting PS1 here is irrelevant because it's overwritten later.
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -A'
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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ----------------------------------------------------------------------------
# Start of Matt's customizations

# Add run time to your prompt.
# See http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/
function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$(($SECONDS - $timer))
  # Also, immediately flush last command to .bash_history
  history -a
  unset timer
}

trap 'timer_start' DEBUG

# Append last command to .bash_history and show elapsed seconds
PROMPT_COMMAND="timer_stop"

function __error_level {
  echo $?
}

function __parse_git_dirty {
  if [[ $(git status --porcelain 2> /dev/null)  ]]; then
    echo "*";
  else
    echo ""
  fi
}

# See https://github.com/jcgoble3/gitstuff/blob/master/gitprompt.sh
git_status() {
    # Outputs a series of indicators based on the status of the
    # working directory:
    # + changes are staged and ready to commit
    # ! unstaged changes are present
    # ? untracked files are present
    # S changes have been stashed
    # P local commits need to be pushed to the remote
    local status="$(git status --porcelain 2>/dev/null)"
    if [[ -n $status ]]; then
        local output=''
        [[ -n $(egrep '^[MADRC]' <<<"$status") ]] && output="$output+"
        [[ -n $(egrep '^.[MD]' <<<"$status") ]] && output="$output!"
        [[ -n $(egrep '^\?\?' <<<"$status") ]] && output="$output?"
        [[ -n $(git stash list) ]] && output="${output}S"
        [[ -n $(git log --branches --not --remotes) ]] && output="${output}P"
        echo $output
    fi
}

# Put the git repository into the prompt
bash_prompt() {

  # regular colors
  local K='\[\033[0;30m\]'    # black
  local R='\[\033[0;31m\]'    # red
  local G='\[\033[0;32m\]'    # green
  local Y='\[\033[0;33m\]'    # yellow
  local B='\[\033[0;34m\]'    # blue
  local M='\[\033[0;35m\]'    # magenta
  local C='\[\033[0;36m\]'    # cyan
  local W='\[\033[0;37m\]'    # white

  # emphasized (bolded) colors
  local BK='\[\033[1;30m\]'
  local BR='\[\033[1;31m\]'
  local BG='\[\033[1;32m\]'
  local BY='\[\033[1;33m\]'
  local BB='\[\033[1;34m\]'
  local BM='\[\033[1;35m\]'
  local BC='\[\033[1;36m\]'
  local BW='\[\033[1;37m\]'

  # reset
  local RESET='\[\033[0;37m\]'

 # PS1="\t $BY\$(__name_and_server)$Y\W $G\$(__git_prompt)$RESET$ "
 # PS1='\[\e]0;\h: \w\a\]\n$(__error_level) ${debian_chroot:+($debian_chroot)}${BY}\u@\h${K}: ${BB}\w [\D{%a} \t]${BG}$(__git_ps1) ${timer_show}s\n${K}\$ '
 PS1='\[\e]0;\h: \w\a\]\n$(__error_level) ${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w [\D{%a} \t]\[\033[01;32m\]$(__git_ps1)$(git_status) ${timer_show}s\n\[\033[00m\]\$ '
}

bash_prompt
unset bash_prompt

# Use colordiff if installed
if hash colordiff 2>/dev/null; then
  export DIFF='colordiff -u'
else
  export DIFF='diff -u'
fi
export EDITOR=vim

alias diff="$DIFF"
alias ack='ack-grep'
alias cd1='cd ..'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
alias cd5='cd ../../../../..'
alias cd6='cd ../../../../../..'

# Search and replace within git
# $1 = search string, $2 = replace string
gitsed() {
  echo "Before:"
  git grep $1
  git grep -lz $1 | xargs -0 -l sed -i -e "s/$1/$2/g"
  echo "After:"
  git grep $2
}

# Setup platform-specific environment
if [ -f "~/.bashrc.`hostname -a`" ]; then
  source "~/.bashrc.`hostname -a`"
elif [ -f "~/settings/bashrc.`hostname -a`" ]; then
  source "~/settings/bashrc.`hostname -a`"
fi

# Manually run git-prompt shell if on mac
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

if [ -e ~/.cargo/bin ]; then
  PATH=~/.cargo/bin:${PATH}
fi

if [ -e ~/.local/bin ]; then
  PATH=~/.local/bin:${PATH}
fi

if [ -e ~/bin ]; then
  PATH=~/bin:${PATH}
fi

# Disable Ctrl-S XON/XOFF. This allows Ctrl-S to be forward search. See https://stackoverflow.com/a/791800
[[ $- == *i* ]] && stty -ixon

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "finished running .bashrc"
