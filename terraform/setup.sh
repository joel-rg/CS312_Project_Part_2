#!/bin/bash

set -e

echo "Updating system packages"
sudo apt update -y

echo "Installing dependencies"
sudo apt install -y openjdk-25-jre-headless wget screen

echo "Creating minecraft user"
sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft || true

echo "Creating directory for server"
sudo mkdir -p /opt/minecraft/server

echo "Downloading server"
cd /opt/minecraft/server

sudo wget https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar -O server.jar

echo "Accepting Minecraft EULA"
echo "eula=true" | sudo tee eula.txt

echo "Setting ownership"
sudo chown -R minecraft:minecraft /opt/minecraft

echo "Creating systemd service"
sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
WorkingDirectory=/opt/minecraft/server

ExecStart=/usr/bin/java -Xmx512M -Xms512M -jar server.jar nogui

ExecStop=/bin/kill -SIGINT \$MAINPID

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd"
sudo systemctl daemon-reload

echo "Enabling Minecraft"
sudo systemctl enable minecraft

echo "Starting Minecraft"
sudo systemctl start minecraft

echo "Minecraft Started"
