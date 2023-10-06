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
