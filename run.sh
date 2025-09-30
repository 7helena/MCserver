#!/usr/bin/env bash

BASE="$HOME/MCserver"

# Start Lobby
screen -dmS Lobby bash -c "cd $BASE/JoooshShack/Lobby && java -Xms1G -Xmx2G -jar fabric-server.jar nogui"

# Start Adventure
screen -dmS Adventure bash -c "cd $BASE/JoooshShack/Adventure && java -Xms1G -Xmx2G -jar fabric-server.jar nogui"

# Start Velocity
screen -dmS Velocity bash -c "cd $BASE/Velocity && java -Xms512M -Xmx1G -jar velocity.jar"

echo "Servers started in screen sessions."
echo "List sessions: screen -ls"
echo "Attach: screen -r Lobby (or Adventure / Velocity)"
echo "Detach: Ctrl+A then D"
