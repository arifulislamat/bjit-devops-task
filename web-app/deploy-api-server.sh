#!/bin/bash

# Create an empty log file
sudo touch /var/log/api-server.log

# Set permissions to the log file
sudo chown admin:admin /var/log/api-server.log

# Define a log file path
LOG_FILE="/var/log/api-server.log"

# Redirect all subsequent output (stdout and stderr) to the log file
exec >> "$LOG_FILE" 

# Update system packages
sudo apt-get update -y

# Install required packages (system-wide)
sudo apt-get install -y python3-pip python3-dev python3-venv git

# Clone API server code from GitHub
git clone https://github.com/arifulislamat/bjit-devops-task.git ~/api-server

# Create a virtual environment for API Server
python3 -m venv ~/api-server/web-app/venv

# Activate the virtual environment
source ~/api-server/web-app/venv/bin/activate

# Install Python packages within the virtual environment
pip install Flask Flask-CORS pymysql redis requests

# Create a systemd service unit file 
sudo tee /etc/systemd/system/api-server.service << EOF
[Unit]
Description=BJIT DevOps API Server

[Service]
User=admin
WorkingDirectory=/home/admin/api-server/web-app
ExecStart=/home/admin/api-server/web-app/venv/bin/python /home/admin/api-server/web-app/api-server.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service unit file
sudo systemctl daemon-reload

# Start and enable the service to run on boot
sudo systemctl start api-server
sudo systemctl enable api-server

# Check the status of the service
sudo systemctl status api-server

# Redirect script output to a log file
exec > ~/script.log 2>&1
