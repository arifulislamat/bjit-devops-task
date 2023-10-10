"""
Copyright (c) 2023 Ariful Islam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Contact Information:
Name: Ariful Islam
Email: arifulislamat@gmail.com
Website: arifulislamat.com
"""
from flask import Flask, jsonify, request, make_response,  Response
from flask_cors import CORS
import pymysql
import redis
import requests


app = Flask(__name__)
CORS(app)

# MySQL connection
def check_mysql_connection():
    try:
        connection = pymysql.connect(
            host='localhost',
            user='musr',
            password='ef02a4db912f',
            database='mdb'
        )
        return "connected"
    except Exception as e:
        return "connection failed"

# Redis connection
def check_redis_connection():
    try:
        connection = redis.StrictRedis(
            host='localhost',
            port=6379,
            db=0
        )
        connection.ping()
        return "connected"
    except Exception as e:
        return "connection failed"

# API END POINT START ---
# Check MySQL Status
@app.route('/api/mysql')
def mysql_status():
    state = check_mysql_connection()
    return jsonify(state=state)

# Check Redis Status
@app.route('/api/redis')
def redis_status():
    state = check_redis_connection()
    return jsonify(state=state)

# File Server URL (replace with the actual URL)
file_server_url = "http://localhost:8081"

# Upload a file to the file server
@app.route('/api/upload', methods=['POST'])
def upload_file():
    try: 
        # Check if the 'file' field exists in the request
        if 'file' not in request.files:
            return jsonify({'error': 'No file part'}), 400

        file = request.files['file']

        # Check if the file has an allowed extension
        allowed_extensions = {'png', 'jpg', 'txt', 'doc', 'pdf'}
        if '.' not in file.filename or file.filename.rsplit('.', 1)[1].lower() not in allowed_extensions:
            return jsonify({'error': 'Invalid file type'}), 400

        # Forward the file to file server
        response = requests.post(f"{file_server_url}/api/upload", files={'file': (file.filename, file.read())})
        
        if response.status_code == 201:
            return jsonify(message="File uploaded successfully."), 201
        else:
            return jsonify(error="Failed to upload file to the file server"), 500
    except Exception as e:
        return jsonify(error="An error occurred while processing the file upload."), 500

# Listing stored files on the file server
@app.route('/api/files')
def files():
    try:
        response = requests.get(f"{file_server_url}/api/files")
        if response.status_code == 200:
            files = response.json().get('files')
            return jsonify(files=files), 200
        else:
            return jsonify(error="Failed to list files from the file server"), 500
    except Exception as e:
        return jsonify(error="An error occurred while listing files from the file server."), 500

# Download a file from the file server
@app.route('/api/download/<filename>')
def download_file(filename):
    try:
        response = requests.get(f"{file_server_url}/api/download/{filename}")
        if response.status_code == 200:
            return Response(response.iter_content(), mimetype='application/octet-stream')
        elif response.status_code == 404:
            return jsonify(error=f"File '{filename}' not found on the file server"), 404
        else:
            return jsonify(error=f"Failed to download file '{filename}' from the file server"), 500
    except Exception as e:
        return jsonify(error="An error occurred while downloading the file from the file server."), 500

# Delete a file on the file server
@app.route('/api/delete/<filename>', methods=['DELETE'])
def delete_file(filename):
    try:
        response = requests.delete(f"{file_server_url}/api/delete/{filename}")
        if response.status_code == 200:
            return jsonify(message=f"File '{filename}' deleted successfully."), 200
        elif response.status_code == 404:
            return jsonify(error=f"File '{filename}' not found on the file server"), 404
        else:
            return jsonify(error=f"Failed to delete file '{filename}' from the file server"), 500
    except Exception as e:
        return jsonify(error="An error occurred while deleting the file from the file server."), 500

# API END POINT FINISH ---

# Start the python app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
