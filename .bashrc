[[ $- != *i* ]] && return

OS="$(uname)"

export HOMEBREW_HOME="/opt/homebrew"
if [[ "${OS}" == "Linux" ]]; then
  export HOMEBREW_HOME="/home/linuxbrew/.linuxbrew" #linux
fi

if [[ "${OS}" == "Darwin" ]]; then
  export HOMEBREW_HOME="/opt/homebrew"
fi

PATH_HOMEBREW_BIN="$HOMEBREW_HOME/bin"
PATH_HOMEBREW_SBIN="$HOMEBREW_HOME/sbin"
PATH_HOMEBREW_GNUBIN="$HOMEBREW_HOME/opt/gnu-sed/libexec/gnubin"
PATH_HOMEBREW_GNUTAR="$HOMEBREW_HOME/opt/gnu-tar/libexec/gnubin"
PATH_HOMEBREW_FINDUTILS="$HOMEBREW_HOME/opt/findutils/libexec/gnubin"
PATH_HOMEBREW_GREP="$HOMEBREW_HOME/opt/grep/libexec/gnubin"
PATH_HOMEBREW_UTIL_LINUX_BIN="$HOMEBREW_HOME/opt/util-linux/bin"
PATH_HOMEBREW_UTIL_LINUX_SBIN="$HOMEBREW_HOME/opt/util-linux/sbin"
PATH_HOMEBREW_COMBINED="$PATH_HOMEBREW_BIN:$PATH_HOMEBREW_SBIN:$PATH_HOMEBREW_GNUBIN:$PATH_HOMEBREW_GNUTAR:$PATH_HOMEBREW_FINDUTILS:$PATH_HOMEBREW_GREP:$PATH_HOMEBREW_UTIL_LINUX_BIN:$PATH_HOMEBREW_UTIL_LINUX_SBIN"
export PATH="$HOME/bin:$PATH_HOMEBREW_COMBINED:/usr/local/bin:$PATH"


alias reload='source ~/.bashrc'
alias dot='git --git-dir=$HOME/.dot/ --work-tree=$HOME'

alias k='kubectl'
alias kx='kubectx'

alias gbda_merged='git fetch -p; git branch --merged | grep -vE "(^\*|master|dev)" | xargs git branch -d'
alias gbda_unmerged='git branch --no-merged | grep -vE "(^\*|master|dev)" | xargs git branch -D'
alias gcdchanges='cd $(git diff --cached --name-only | xargs dirname | uniq)'
alias gcdroot='pushd $(git rev-parse --show-toplevel)'

alias dot='git --git-dir=$HOME/.dot/ --work-tree=$HOME'

alias tg='terragrunt'
alias tgproviders='rm -f .terraform.locks.hcl; terragrunt providers lock -platform=linux_arm64 -platform=linux_amd64 -platform=darwin_amd64 -platform=darwin_arm64 -platform=windows_amd64'

alias ls="eza --icons=always"
alias cat='bat'
alias pp='pbpaste'
alias yy='pbcopy'
alias cd="z"

eval "$(direnv hook bash)"
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"
eval "$(zoxide init bash)"

export BAT_THEME="Sublime Snazzy"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-

if [[ -f "$HOME/.localrc" ]]; then
  source "$HOME/.localrc"
fi

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

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

source ~/fzf-git.sh/fzf-git.sh

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
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
