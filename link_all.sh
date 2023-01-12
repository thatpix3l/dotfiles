#!/bin/sh

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$(repo_dir)"

link_items() {
    local repo_items_dir="$repo_dir/$1"; shift
    local dest_root="$1"; shift

    find "$repo_items_dir/" -mindepth 1 -maxdepth 1 2> /dev/null | while read -r repo_item; do

        ln -s "$repo_item" "$dest_root/" &&
		echo "Created symlink from \"$repo_item\" to \"$dest_root\""

    done
}

link_items home "$HOME"
link_items config "$HOME/.config"

