#!/usr/bin/env sh


# note, we cannot create a session without a window
session=config
if ! tmux has-session -t "$session" 2>/dev/null; then
  tmux new-session -d -s "$session" -n "shell" -c "$~/.config/"
fi

new_window() {
  window_name=$1
  directory=$2
  command=$3
  if ! tmux has-session -t "$session:$window_name" 2>/dev/null; then 
    # if the new window does not exit, create it, targeting the session
    tmux new-window -n "$window_name" -t "$session" -c "$directory" \; send-keys -t "$session:$window_name" "$command" C-m 
  fi
}

new_window "nvim conf" "~/.config/nvim" "nvim -c NvimTreeFocus"
new_window "tmux conf" "~/.config/tmux" "nvim -c NvimTreeFocus"
new_window "fish conf" "~/.config/fish/" "nvim -c NvimTreeFocus"
