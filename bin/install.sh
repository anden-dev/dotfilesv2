#!/usr/bin/env bash

git clone --bare https://github.com/anden-dev/dotfilesv2.git "$HOME/.dot" || exit

echo "*" >~/.gitignore

# checkout
git --git-dir="$HOME/.dot" --work-tree="$HOME" checkout

cd "$HOME" || exit

git --git-dir="$HOME/.dot/" --work-tree="$HOME" sparse-checkout set --no-cone '/*' '!/bin/' '!LICENSE' '!README.md'

alias dot='git --git-dir=$HOME/.dot/ --work-tree=$HOME'
