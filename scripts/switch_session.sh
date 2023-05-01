#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function main {
	if [[ $# -eq 1 ]]; then
		selected=$1
	else
		selected=$(find ~/repos/ -mindepth 1 -maxdepth 2 -type d | fzf)
	fi
	selected_name=$(basename "$selected" | tr . _)
	tmux_running=$(pgrep tmux)
	if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
		tmux new-session -s $selected_name -c $selected
	fi
	if ! tmux has-session -t=$selected_name 2>/dev/null; then
		tmux new-session -ds $selected_name -c $selected
	fi
	tmux switch-client -t $selected_name
}
main
