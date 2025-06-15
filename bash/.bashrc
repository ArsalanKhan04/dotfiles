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
alias nvcpf="nvim -c 'lua SPL(true)'"
alias nvcp="nvim -c 'lua SPL(false)'"

neofetch

alias get_idf=". /home/krakar/esp/esp-idf/export.sh"

export CLOUDSDK_ROOT_DIR=/opt/google-cloud-cli
export CLOUDSDK_PYTHON=/usr/bin/python
export CLOUDSDK_PYTHON_ARGS='-S -W ignore'
export PATH=$CLOUDSDK_ROOT_DIR/bin:$PATH
export GOOGLE_CLOUD_SDK_HOME=$CLOUDSDK_ROOT_DIR

alias cfprobs="python /home/krakar/Files/CP/getprobs.py"

source /home/krakar/.config/broot/launcher/bash/br
