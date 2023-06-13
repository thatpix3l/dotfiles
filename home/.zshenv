# Unique paths
path=(
  /usr/local/{,s}bin(N)
  $HOME/.local/bin
  $path
)
typeset -gU cdpath fpath mailpath path

choose_editor() {
    for cmd in "$@"; do
        command -v "$cmd" > /dev/null && export EDITOR="$cmd" && break
    done
}

choose_editor neovide nvim vim vi nano

# Generic shell history file settings
HISTSIZE=100000000
SAVEHIST=100000000

# Less command history file
LESSHISTFILE="${HOME}/.cache/less/history.txt"

