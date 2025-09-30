#!/bin/bash

# Install tmux if not already installed
if ! command -v tmux &> /dev/null; then
    echo "tmux not found, installing..."
    sudo apt-get update
    sudo apt-get install -y tmux
fi 
# Tmux is installed, proceed to start servers
echo "Starting servers in tmux sessions..."

# function to start a server in its own tmux session
start_server() {
    local name=$1
    local dir=$2
    local jar=$3
    local mem=$4

    cd "$dir" || exit
    tmux new-session -d -s "$name" "java -Xmx${mem} -Xms${mem} -jar $jar nogui"
    cd - > /dev/null || exit
}

# Start Lobby server
start_server "lobby" "$HOME/JoooshShack/Lobby" "fabric-server.jar" "4G"

# Start Adventure server
start_server "adventure" "$HOME/JoooshShack/Adventure" "fabric-server.jar" "4G"

# Start Survival server (uncomment if you want it)
# start_server "survival" "$HOME/JoooshShack/Survival" "fabric-server.jar" "4G"

# Start Velocity proxy
start_server "velocity" "$HOME/Velocity" "velocity.jar" "2G"

# Show running tmux sessions
tmux ls
