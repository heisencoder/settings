# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

#============================================================================
# Start of Matt's customizations

# Change the window title of X terminals
case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome)
    # Commenting out because it interferes with bashrc and doesn't seem to work.
    #export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*} as ${USER}:${PWD/$HOME/~}\007"'
    ;;
  screen*)
    #export PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    # Change directories to the tmux directory
    ;;
esac

# Save the last command into the history file
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Always append when saving history instead of overwriting the whole file.
shopt -s histappend

# run BASH in vi mode
set -o vi

if [ -n "$DISPLAY" ]; then
  # Disable flow control (i.e., Ctrl-S and Ctrl-Q)
  # Note: This causes startup issues.
  # stty -ixon

  # Disable the lower-power mode for the screensaver.  (It takes too long for the
  # monitor to come out of lower-power mode, and I intend to manually turn the
  # monitor off at night.)
  xset -dpms

  # Increase keyboard repeat rate to something reasonable
  xset r rate 300 30
fi

# Enable directory expansion via ** operator
shopt -s globstar

# These are also defined in .bashrc, but are here in case I run 'sh' or 'ksh'.
# This is to avoid truncating the ~/.bash_history file with the default
# HISTSIZE of about 500 lines.
HISTCONTROL=ignoreboth
HISTSIZE=1000000
HISTFILESIZE=2000000

# Indicate that we're done
echo "Ran ~/.profile"
