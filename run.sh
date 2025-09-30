#!/usr/bin/env bash

BASE="$HOME/MCserver"

# Ensure logs directory exists
mkdir -p "$BASE/logs"

# Start Lobby
screen -dmS Lobby bash -c "cd $BASE/JoooshShack/Lobby && java -Xms1G -Xmx2G -jar fabric-server.jar nogui | tee -a $BASE/logs/Lobby.log"

# Start Adventure
screen -dmS Adventure bash -c "cd $BASE/JoooshShack/Adventure && java -Xms1G -Xmx2G -jar fabric-server.jar nogui | tee -a $BASE/logs/Adventure.log"

# Start Velocity
screen -dmS Velocity bash -c "cd $BASE/Velocity && java -Xms512M -Xmx1G -jar velocity.jar | tee -a $BASE/logs/Velocity.log"

echo "Servers started in screen sessions."
echo "List: screen -ls"
echo "Attach: screen -r Lobby (or Adventure / Velocity)"
echo "Detach: Ctrl+A then D"
echo "Logs in: $BASE/logs/"
