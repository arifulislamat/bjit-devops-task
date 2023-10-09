#!/bin/bash
#
# Copyright (c) 2023 Ariful Islam
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Contact Information:
# Name: Ariful Islam
# Email: arifulislamat@gmail.com
# Website: arifulislamat.com
#

# Create an empty log file
sudo touch /var/log/file-server.log

# Set permissions to the log file
sudo chown admin:admin /var/log/file-server.log

# Define a log file path
LOG_FILE="/var/log/file-server.log"

# Redirect all subsequent output (stdout and stderr) to the log file
exec >> "$LOG_FILE" 

# Update system packages
sudo apt-get update -y

# Install required packages (system-wide)
sudo apt-get install -y python3-pip python3-dev python3-venv git

# Clone API server code from GitHub
git clone https://github.com/arifulislamat/bjit-devops-task.git /home/admin/file-server

# Set permission for file-server dir
sudo chown admin:admin /home/admin/file-server

# Create a virtual environment for API Server
python3 -m venv /home/admin/file-server/web-app/venv

# Activate the virtual environment
source /home/admin/file-server/web-app/venv/bin/activate

# Install Python packages within the virtual environment
pip install Flask Flask-CORS

# Create a systemd service unit file 
sudo tee /etc/systemd/system/file-server.service << EOF
[Unit]
Description=BJIT DevOps API Server

[Service]
User=admin
WorkingDirectory=/home/admin/file-server/web-app
ExecStart=/home/admin/file-server/web-app/venv/bin/python /home/admin/file-server/web-app/file-server.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service unit file
sudo systemctl daemon-reload

# Start and enable the service to run on boot
sudo systemctl start file-server
sudo systemctl enable file-server

# Check the status of the service
sudo systemctl status file-server

# Exit statement
exit 0