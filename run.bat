@echo off
REM Start Lobby server
cd JoooshShack\Lobby
start "Lobby Server" java -Xmx4G -Xms4G -jar fabric-server.jar nogui
cd ..\..

REM Start Adventure server
cd JoooshShack\Adventure
start "Adventure Server" java -Xmx4G -Xms4G -jar fabric-server.jar nogui
cd ..\..

REM Start Survival server
REM cd JoooshShack\Survival
REM start "Survival Server" java -Xmx4G -Xms4G -jar fabric-server.jar nogui
cd ..\..

ECHO List directories
dir

REM Start Velocity proxy
cd Velocity
start "Velocity Proxy" java -Xmx2G -Xms2G -jar velocity.jar
