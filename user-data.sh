#!/bin/bash
# Update system packages
sudo apt-get update -y

# Install required packages (system-wide)
sudo apt-get install -y python3-pip python3-dev git

# Install virtualenv for creating virtual environments
sudo apt-get install -y python3-venv

# Create a directory for your Flask application
mkdir -p ~/py-backend

# Clone your python backend api server code from GitHub
git clone https://github.com/arifulislamat/bjit-devops-task.git ~/py-backend

# Create a virtual environment for your Flask application
python3 -m venv ~/py-backend/web-app/venv

# Activate the virtual environment
source ~/py-backend/web-app/venv/bin/activate

# Install Python packages within the virtual environment
pip install Flask Flask-CORS pymysql redis

# Create a systemd service unit file 
sudo tee /etc/systemd/system/py-backend.service << EOF
[Unit]
Description=BJIT DevOps API Server

[Service]
User=admin
WorkingDirectory=/home/admin/py-backend/web-app
ExecStart=/home/admin/py-backend/web-app/venv/bin/python /home/admin/py-backend/web-app/backend.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service unit file
sudo systemctl daemon-reload

# Start and enable the service to run on boot
sudo systemctl start py-backend
sudo systemctl enable py-backend

# Check the status of the service
sudo systemctl status py-backend
