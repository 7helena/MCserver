#!/bin/bash

# Start Lobby server
cd ~/JoooshShack/Lobby || exit
gnome-terminal -- bash -c "java -Xmx4G -Xms4G -jar fabric-server.jar nogui; exec bash"
cd ../../

# Start Adventure server
cd ~/JoooshShack/Adventure || exit
gnome-terminal -- bash -c "java -Xmx4G -Xms4G -jar fabric-server.jar nogui; exec bash"
cd ../../

# Start Survival server
cd ~/JoooshShack/Survival || exit
gnome-terminal -- bash -c "java -Xmx4G -Xms4G -jar fabric-server.jar nogui; exec bash"
cd ../../

# List directories
ls

# Start Velocity proxy
cd ~/Velocity || exit
gnome-terminal -- bash -c "java -Xmx2G -Xms2G -jar velocity.jar; exec bash"
