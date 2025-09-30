#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$HOME/MCserver"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

# Check tmux
if command -v tmux >/dev/null 2>&1; then
  HAS_TMUX=1
else
  HAS_TMUX=0
  echo "tmux not found — using background nohup processes."
fi

start_server() {
  local name="$1"
  local dir="$2"
  local jar="$3"
  local mem_min="$4"
  local mem_max="$5"

  if [ ! -d "$dir" ]; then
    echo "Skipping $name: directory $dir not found."
    return
  fi

  if [ "$HAS_TMUX" -eq 1 ]; then
    tmux new-session -d -s "$name" \
      "bash -lc 'cd \"$dir\" && exec java -Xms${mem_min} -Xmx${mem_max} -jar \"$jar\" nogui'"
    echo "Started tmux session: $name"
  else
    nohup bash -c "cd \"$dir\" && java -Xms${mem_min} -Xmx${mem_max} -jar \"$jar\" nogui" \
      > "$LOG_DIR/${name}.log" 2>&1 &
    echo "Started $name in background. Log: $LOG_DIR/${name}.log"
  fi
}

# Memory allocations (for 8GB total system)
# OS + Umbrel ~1.5GB
# Velocity ~1GB
# Servers ~1.5-2GB each

start_server "lobby"     "$BASE_DIR/JoooshShack/Lobby"     "fabric-server.jar" 1G 2G
start_server "adventure" "$BASE_DIR/JoooshShack/Adventure" "fabric-server.jar" 1G 2G
start_server "survival"  "$BASE_DIR/JoooshShack/Survival"  "fabric-server.jar" 1G 2G
start_server "velocity"  "$BASE_DIR/Velocity"  "velocity.jar"       512M 1G

# Show running tmux sessions
if [ "$HAS_TMUX" -eq 1 ]; then
  echo
  tmux ls || true
  echo "Attach with: tmux attach -t <session-name>"
else
  echo
  echo "Background processes started. Check logs in $LOG_DIR."
fi
