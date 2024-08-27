#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


[ -n "$XTERM_VERSION" ] && transset-df 0.85 --id "$WINDOWID" >/dev/null

export PATH="/home/krakar/.cargo/bin:$PATH"

alias openst='cd /home/krakar/uni/study'

alias activetukl='source /home/krakar/uni/tukl/tuklenv/bin/activate'

eval "$(zoxide init --cmd cd bash)"
. "$HOME/.cargo/env"

alias tsm="transmission-remote"

neofetch
