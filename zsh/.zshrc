#!/usr/bin/env zsh

# ----- Homebrew -----
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- ENV -----
export LANG=en_US.UTF-8
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export ABBR_USER_ABBREVIATIONS_FILE=$HOME/dotfiles/zsh-abbr/abbr

# ----- OMZ -----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="lambda"
zstyle ':omz:update' mode reminder
plugins=(git)
zstyle ':omz:*' aliases no # Skip all aliases, in lib files and enabled plugins
source $ZSH/oh-my-zsh.sh

# ------ EDITORS -----
EDITOR=nvim

if [[ -n ${SSH_CONNECTION:-} ]]; then
  export EDITOR='vim'
else
  export EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi
alias e="$EDITOR"

# ----- SCRIPTS -----
alias awsenv="python $HOME/workspace/_scripts/switch_aws_env.py"
alias biu="brew_install_update"
alias gcb="$HOME/workspace/_scripts/git_clone_bare.sh" # Clones a repo with a bare git dir and single worktree
alias k8s="$HOME/workspace/_scripts/kube_switch.sh"

# ----- FUNCTIONS ------
# Homebrew
bu() {
  brew update &&
  brew upgrade &&
  brew cleanup
}

brew_install_update() {
  local package="$1"
  brew install "$package"
  if [[ $? -eq 0 ]]; then
    pushd $HOME/dotfiles/homebrew/ > /dev/null
    echo "$package" >> packages
    popd > /dev/null
  else
    echo "Failed to install $package"
  fi
}

# Daily Logs
daily() {
  local daily_dir="$HOME/workspace/_dailies/"
  local date_format=$(date +"%Y_%m_%d")
  local today="${date_format}.md"
  cd "$daily_dir"
  $EDITOR +e "$today"
}

# General Notes
note() {
  local note_dir="$HOME/workspace/_notes/"
  local date_format=$(date +"%Y_%m_%d")
  local today="${date_format}.md"
  cd "$note_dir"
  $EDITOR +e "$today"
}

# Questions
q() {
  local note_dir="$HOME/workspace/_notes/"
  local question_file="questions.md"
  cd "$note_dir"
  $EDITOR +e "$question_file"
}

# ----- APPLICATION SPECIFIC SETTINGS -----

# ----- asdf -----
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# ----- fzf -----
eval "$(fzf --zsh)"
set rtp+=/opt/homebrew/opt/fzf # for Vim

# ----- abbr -----
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh # Toward end
