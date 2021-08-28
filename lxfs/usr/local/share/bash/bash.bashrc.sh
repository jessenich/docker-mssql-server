# shellcheck shell=bash
# shellcheck disable=SC1091

export OSH=/usr/local/share/oh-my-bash
export OSH_THEME="powerline-multiline"
export HYPHEN_INSENSITIVE="true"
export DISABLE_AUTO_UPDATE="true"
export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="yyyy-mm-dd"
export OSH_CUSTOM=/usr/local/share/oh-my-bash/custom

export completions=(
  git
  composer
  ssh
)

export aliases=(
  chmod
  general
  ls
  misc
)

export plugins=(
  git
  bashmarks
)

source "$OSH/oh-my-bash.sh"

export LANG=en_US.UTF-8
export EDITOR='nano'

if [ -f "/home/${USER}/.ssh/rsa_id" ]; then
    export SSH_KEY_PATH="/home/${USER}/.ssh/rsa_id"
fi

edit-bash-config() { $EDITOR ~/.bashrc; }
edit-oh-my-bash() { $EDITOR "$OSH/oh-my-bash"; }
src-oh-my-bash() { source "$OSH/oh-my-bash"; }
src-bashrc() { source ~/.bashrc; }
