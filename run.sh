#!/usr/bin/env bash

BASE="$HOME/MCserver"

tmux new-session -d -s Lobby "cd $BASE/JoooshShack/Lobby && java -Xmx2G -Xms1G -jar fabric-server.jar nogui"
tmux new-session -d -s Adventure "cd $BASE/JoooshShack/Adventure && java -Xmx2G -Xms1G -jar fabric-server.jar nogui"
tmux new-session -d -s Velocity "cd $BASE/Velocity && java -Xmx1G -Xms512M -jar velocity.jar nogui"

tmux ls
echo "Use: tmux attach -t Lobby (or Adventure / Velocity)"
echo "To stop a server, use: tmux kill-session -t Lobby (or Adventure / Velocity)"