#!/usr/bin/env bash
set -euo pipefail
# DONT RUN WITH SUDO

# Base folder
BASE_DIR="$HOME/MCserver"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

# Check for tmux
if command -v tmux >/dev/null 2>&1; then
  HAS_TMUX=1
else
  HAS_TMUX=0
  echo "tmux not found — will run servers in background (nohup)."
fi

start_server() {
  local name="$1"
  local dir="$2"
  local jar="$3"
  local mem="$4"

  if [ ! -d "$dir" ]; then
    echo "Skipping $name: directory $dir not found."
    return
  fi

  if [ "$HAS_TMUX" -eq 1 ]; then
    tmux new-session -d -s "$name" "bash -lc 'cd \"$dir\" && exec java -Xmx${mem} -Xms${mem} -jar \"$jar\" nogui'"
    echo "Started tmux session: $name"
  else
    nohup bash -c "cd \"$dir\" && java -Xmx${mem} -Xms${mem} -jar \"$jar\" nogui" > "$LOG_DIR/${name}.log" 2>&1 &
    echo "Started $name in background. Log: $LOG_DIR/${name}.log"
  fi
}

# Adjust these if your folders are named differently
start_server "lobby"    "$BASE_DIR/Lobby"     "fabric-server.jar" "4G"
start_server "adventure" "$BASE_DIR/Adventure" "fabric-server.jar" "4G"
#start_server "survival"  "$BASE_DIR/Survival"  "fabric-server.jar" "4G"
start_server "velocity" "$BASE_DIR/Velocity" "velocity.jar" "2G"

if [ "$HAS_TMUX" -eq 1 ]; then
  echo
  tmux ls || true
  echo "Attach with: tmux attach -t <session-name>"
else
  echo
  echo "Background processes started. Check logs in $LOG_DIR."
fi
