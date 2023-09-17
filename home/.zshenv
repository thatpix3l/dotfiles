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

# Nvidia shader cache
__GL_SHADER_DISK_CACHE_PATH="${HOME}/.cache/nvidia/shader"
mkdir -p "${__GL_SHADER_DISK_CACHE_PATH}"

# Rust stuff
CARGO_ENV="$HOME/.cargo/env"
test -f "$CARGO_ENV" && . "$CARGO_ENV"
