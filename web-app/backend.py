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
from flask import Flask, jsonify
from flask_cors import CORS
import pymysql
import redis

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

@app.route('/api/mysql')
def mysql_status():
    state = check_mysql_connection()
    return jsonify(state=state)

@app.route('/api/redis')
def redis_status():
    state = check_redis_connection()
    return jsonify(state=state)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
