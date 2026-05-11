# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# Use KDE askpass dialog for sudo
alias sudo='sudo -A'

eval "$(~/.local/bin/mise activate bash)"

# opencode
export PATH=/home/al3rez/.opencode/bin:$PATH
eval "$(starship init bash)"
export SUDO_ASKPASS=/usr/bin/ksshaskpass

# Added by flyctl installer
export FLYCTL_INSTALL="/home/al3rez/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

alias cl="claude --dangerously-skip-permissions"

# Google Cloud SDK
source ~/google-cloud-sdk/path.bash.inc
source ~/google-cloud-sdk/completion.bash.inc

export CDPATH=~/Documents/Github/

# Ghostty tab name: petname + random emoji, generated once per shell
if [ -z "$GHOSTTY_TAB_NAME" ] && [ -t 1 ] && [ -x "$HOME/.local/bin/ghostty-tabname" ]; then
  export GHOSTTY_TAB_NAME="$($HOME/.local/bin/ghostty-tabname 2>/dev/null)"
fi
if [ -n "$GHOSTTY_TAB_NAME" ]; then
  _ghostty_set_title() { printf '\033]0;%s\007\033]30;%s\007' "$GHOSTTY_TAB_NAME" "$GHOSTTY_TAB_NAME"; }
  PROMPT_COMMAND="_ghostty_set_title${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi
