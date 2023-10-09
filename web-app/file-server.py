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
from flask import Flask, request, send_from_directory, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

# Directory to store uploaded files
UPLOAD_DIR = 'uploads' 
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'gif'}

app.config['UPLOAD_DIR'] = UPLOAD_DIR

# Check if the file extension is allowed
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# API END POINT START ---
# Endpoint to upload a file
@app.route('/api/upload', methods=['POST'])
def upload_file():
    print(request.files)
    if 'file' not in request.files:
        return jsonify(error="No file part"), 400
    print(request.files)
    file = request.files['file']

    if file.filename == '':
        return jsonify(error="No selected file"), 400

    if file and allowed_file(file.filename):
        filename = file.filename
        file.save(os.path.join(app.config['UPLOAD_DIR'], filename))
        return jsonify(message="File uploaded successfully."), 201

    return jsonify(error="Invalid file type"), 400

# Listing stored files
@app.route('/api/files')
def list_files():
    files = os.listdir(app.config['UPLOAD_DIR'])
    return jsonify(files=files), 200

# Download a file
@app.route('/api/download/<filename>')
def download_file(filename):
    return send_from_directory(app.config['UPLOAD_DIR'], filename)

# Delete a stored file
@app.route('/api/delete/<filename>', methods=['DELETE'])
def delete_file(filename):
    try:
        file_path = os.path.join(app.config['UPLOAD_DIR'], filename)

        # Check if the file exists
        if os.path.exists(file_path):
            os.remove(file_path)
            return jsonify(message=f"File '{filename}' deleted successfully."), 200
        else:
            return jsonify(error=f"File '{filename}' not found."), 404
    except Exception as e:
        return jsonify(error="An error occurred while deleting the file."), 500
# API END POINT FINISH ---

if __name__ == '__main__':
    if not os.path.exists(UPLOAD_DIR):
        os.makedirs(UPLOAD_DIR)
    app.run(host='0.0.0.0', port=8081)