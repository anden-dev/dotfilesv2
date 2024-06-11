# dotfilesv2

After considering stow or nix, this is a pure git driven solution to tame my dotfiles.


## Requirements for use

- git
- curl

## Requirements for contribution (check pre-commit config)

- pre-commit
- shfmt
- shellcheck
- gitleaks


Install
---

Install [brew](https://brew.sh/) first (follow the instructions from the homebrew website)

Please read the script before executing:

    curl -Lks https://raw.githubusercontent.com/anden-dev/dotfilesv2/main/bin/install.sh | /bin/bash


In a nutshell
---

This:

- creates a bare repo in `~/.dot` and track all the files in the `~`.
- adds all files in `~` to `.gitignore`, so that we don't add any private files into git inadvertently (files MUST be added forcefully using `-f` flag)
- creates a special git alias named [`dot`](/.config/fish/functions/dot.fish) which is specifilly for working with the dotfiles located in `~`


Usage
---

    dot add -f .a-dot-file
    dot commit -m "Added .a-dot-file"
    dot push origin master

## Installation

Carefull idiot install (check the script before you run this)
```sh
curl -Lks https://raw.githubusercontent.com/anden-dev/dotfilesv2/main/.bin/install.sh | /bin/bash
```

```sh
alias dot='git --git-dir=$HOME/.dot/ --work-tree=$HOME'
```
