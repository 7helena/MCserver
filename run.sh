#!/usr/bin/env bash
set -euo pipefail

# Determine the non-root user home even if script is run with sudo.
TARGET_USER="${SUDO_USER:-$USER}"
BASE_DIR="$(getent passwd "$TARGET_USER" 2>/dev/null | cut -d: -f6 || echo "/home/$TARGET_USER")"

echo "Using base dir: $BASE_DIR (user: $TARGET_USER)"

LOG_DIR="$BASE_DIR/JoooshShack/logs"
mkdir -p "$LOG_DIR"

# Check tmux availability
if command -v tmux >/dev/null 2>&1; then
  HAS_TMUX=1
else
  HAS_TMUX=0
  echo "tmux not found — will use nohup background processes and logs in $LOG_DIR."
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
    echo "Started $name in background (nohup). Log: $LOG_DIR/${name}.log"
  fi
}

# edit these if your folders are in different places
start_server "lobby"    "$BASE_DIR/JoooshShack/Lobby"     "fabric-server.jar" "4G"
start_server "adventure" "$BASE_DIR/JoooshShack/Adventure" "fabric-server.jar" "4G"
#start_server "survival"  "$BASE_DIR/JoooshShack/Survival"  "fabric-server.jar" "4G"

start_server "velocity" "$BASE_DIR/Velocity" "velocity.jar" "2G"

if [ "$HAS_TMUX" -eq 1 ]; then
  echo
  tmux ls || true
  echo "Attach with: tmux attach -t <session-name> (e.g. tmux attach -t lobby)"
else
  echo
  echo "Background processes started. Check logs in $LOG_DIR or use 'ps aux | grep java' to find them."
fi
