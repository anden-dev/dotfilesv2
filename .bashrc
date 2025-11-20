[[ $- != *i* ]] && return

export LS_COLORS="$(vivid generate catppuccin-macchiato)"

OS="$(uname)"

export HOMEBREW_HOME="/opt/homebrew"
if [[ "${OS}" == "Linux" ]]; then
  export HOMEBREW_HOME="/home/linuxbrew/.linuxbrew" #linux
fi

if [[ "${OS}" == "Darwin" ]]; then
  export HOMEBREW_HOME="/opt/homebrew"
fi

#PATH_HOMEBREW_GNUBIN="$(brew --prefix coreutils)/libexec/gnubin"

# Homebrew paths
PATH_HOMEBREW_BIN="$HOMEBREW_HOME/bin"
PATH_HOMEBREW_SBIN="$HOMEBREW_HOME/sbin"
PATH_HOMEBREW_GNU_COREUTILS="$HOMEBREW_HOME/opt/uutils-coreutils/libexec/uubin"
PATH_HOMEBREW_GNU_SED="$HOMEBREW_HOME/opt/gnu-sed/libexec/gnubin"
PATH_HOMEBREW_GNU_TAR="$HOMEBREW_HOME/opt/gnu-tar/libexec/gnubin"
PATH_HOMEBREW_FINDUTILS="$HOMEBREW_HOME/opt/findutils/libexec/gnubin"
PATH_HOMEBREW_GREP="$HOMEBREW_HOME/opt/grep/libexec/gnubin"
PATH_HOMEBREW_UTIL_LINUX_BIN="$HOMEBREW_HOME/opt/util-linux/bin"
PATH_HOMEBREW_UTIL_LINUX_SBIN="$HOMEBREW_HOME/opt/util-linux/sbin"


# Final PATH
export PATH="\
$HOME/bin:\
$PATH_HOMEBREW_BIN:\
$PATH_HOMEBREW_SBIN:\
$PATH_HOMEBREW_GNU_COREUTILS:\
$PATH_HOMEBREW_GNU_SED:\
$PATH_HOMEBREW_GNU_TAR:\
$PATH_HOMEBREW_FINDUTILS:\
$PATH_HOMEBREW_GREP:\
$PATH_HOMEBREW_UTIL_LINUX_BIN:\
$PATH_HOMEBREW_UTIL_LINUX_SBIN:\
$HOME/.local/bin:\
/usr/local/bin:\
$PATH"


# Remove duplicates from PATH.
# Note: In Bash, you don't need `-U` for export.
#export PATH=$(echo $PATH | tr ':' '\n' | awk '!x[$0]++' | tr '\n' ':')


dot() {
  command /opt/homebrew/bin/git --git-dir="$HOME/.dot" --work-tree="$HOME" "$@"
}


source $HOME/bin/project_push_env.sh

alias k='kubecolor'
alias kx='kubectx'

alias gbda_merged='git fetch -p; git branch --merged | grep -vE "(^\*|master|dev)" | xargs git branch -d'
alias gbda_unmerged='git branch --no-merged | grep -vE "(^\*|master|dev)" | xargs git branch -D'
alias gcdchanges='cd $(git diff --cached --name-only | xargs dirname | uniq)'
alias gcdroot='pushd $(git rev-parse --show-toplevel)'
alias gresettags='git tag -l | xargs git tag -d && git fetch -t'


alias tg='terragrunt'
alias tgvlatest='gum spin --spinner monkey --title "Getting latest terrgrunt..." -- sleep 1; curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"'"'tag_name'"'"' | sed -E '"'"'s/.*"v?([^"]+)".*/\1/'"'"''

alias tgay='terragrunt --terragrunt-forward-tf-stdout apply -auto-approve'
alias tgdy='terragrunt --terragrunt-forward-tf-stdout destroy -auto-approve'
alias tgpr='rm -f .terraform.locks.hcl; gum spin --spinner globe --title "Getting provider hashes..." -- terragrunt providers lock -platform=linux_arm64 -platform=linux_amd64 -platform=darwin_amd64 -platform=darwin_arm64 -platform=windows_amd64'

alias ls="eza --icons=always"
alias cat='bat'
alias pp='pbpaste'
alias yy="tr -d '\n' | pbcopy"
alias jj='pbpaste | jsonpp | pbcopy'
alias jjj='pbpaste | jsonpp'

alias cd="z"
alias vim="nvim"
alias vi="nvim"

alias policybot_disallow_squash="yq4 eval '.repository.allow_squash_merge = false' -i .settingsbot.yml"
alias policybot_remove_template="yq4 eval '.repository.is_template = false' -i .settingsbot.yml"

function title {
  echo -ne "\033]0;"$*"\007"
}

alias title_update='title "$(basename $(pwd))"'

eval "$(brew shellenv)"
eval "$(register-python-argcomplete pipx)"
eval "$(mise activate bash)"
eval "$(direnv hook bash)"
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(thefuck --alias fk)"
eval "$(zoxide init bash)"
eval "$(atuin init bash --disable-up-arrow)"
source -- ~/.local/share/blesh/ble.sh


export BLE_GIT_COMPLETION=0
complete -r git 2>/dev/null || true
# disable prompt git status widget (common bleed-through culprit)
unset -f get git root 2>/dev/null || true


# tab completion
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
source <(carapace _carapace)

# config exports
export BAT_THEME="Catppuccin Macchiato"
export EDITOR='nvim'
export VEDITOR='zed'
export VISUAL=$EDITOR
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

#source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
  cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo \${}'" "$@" ;;
  *) fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

#[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

if [[ -f "$HOME/.localrc" ]]; then
  source "$HOME/.localrc"
fi

function check_certs() {
  if [ -z "$1" ]; then
    echo "domain name missing"
    exit 1
  fi
  name="$1"
  shift

  now_epoch=$(date +%s)

  dig +noall +answer $name | while read _ _ _ _ ip; do
    echo -n "$ip:"
    expiry_date=$(echo | openssl s_client -showcerts -servername $name -connect $ip:443 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2)
    echo -n " $expiry_date"
    expiry_epoch=$(date -d "$expiry_date" +%s)
    expiry_days="$((($expiry_epoch - $now_epoch) / (3600 * 24)))"
    echo "    $expiry_days days"
  done
}

export MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{
if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
else if (NF>3) print $1 "/" $2 "/.../" $NF;
else print $1 "/.../" $NF; }
else print $0;}'"'"')'
PS1='$(eval "echo ${MYPS}")$ '
