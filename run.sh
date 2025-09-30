#!/usr/bin/env bash
set -euo pipefail

# Base directories
BASE_DIR="$HOME/MCserver/JoooshShack"
VELOCITY_DIR="$HOME/MCserver/Velocity"
LOG_DIR="$HOME/MCserver/logs"
mkdir -p "$LOG_DIR"

# Check tmux availability
if command -v tmux >/dev/null 2>&1; then
  HAS_TMUX=1
else
  HAS_TMUX=0
  echo "tmux not found — using background nohup processes."
fi

# Servers and memory allocations
declare -A SERVERS
SERVERS=(
  ["lobby"]="1G 2G"
  ["adventure"]="1G 2G"
  ["survival"]="1G 2G"
)

start_server() {
  local name="$1"
  local mem_min="$2"
  local mem_max="$3"
  local dir="$BASE_DIR/$name"
  local jar="fabric-server.jar"

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

start_velocity() {
  local mem_min="512M"
  local mem_max="1G"
  local jar="velocity.jar"

  if [ ! -d "$VELOCITY_DIR" ]; then
    echo "Skipping Velocity: directory $VELOCITY_DIR not found."
    return
  fi

  if [ "$HAS_TMUX" -eq 1 ]; then
    tmux new-session -d -s "velocity" \
      "bash -lc 'cd \"$VELOCITY_DIR\" && exec java -Xms${mem_min} -Xmx${mem_max} -jar \"$jar\" nogui'"
    echo "Started tmux session: velocity"
  else
    nohup bash -c "cd \"$VELOCITY_DIR\" && java -Xms${mem_min} -Xmx${mem_max} -jar \"$jar\" nogui" \
      > "$LOG_DIR/velocity.log" 2>&1 &
    echo "Started velocity in background. Log: $LOG_DIR/velocity.log"
  fi
}

echo "Starting Minecraft servers..."

# Start all servers
for name in "${!SERVERS[@]}"; do
  mems=(${SERVERS[$name]})
  start_server "$name" "${mems[0]}" "${mems[1]}"
done

# Start Velocity proxy
start_velocity

# Show running tmux sessions
if [ "$HAS_TMUX" -eq 1 ]; then
  echo
  tmux ls || echo "No tmux sessions running."
  echo "Attach with: tmux attach -t <session-name>"
else
  echo
  echo "Background processes started. Check logs in $LOG_DIR."
fi
