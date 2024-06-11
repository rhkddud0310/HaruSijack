"""
## Projectr : 하루시작 프로젝트 Flask Server
## Description : 
    -  Rest api 를 위한 서버 
## Author :  (담당) 박지환, 박동근
## Date : 2024.06.10 ~
## Detail : 
    - http://localhost:5000/analyze
## Update: 
    - 2024.06.02 J.park : swift - flask 통신 구축

"""

from flask import Flask, request, jsonify
from flask_cors import CORS
# import joblib
import json 

app = Flask(__name__)
CORS(app)  
@app.route('/analyze', methods=['POST'])
def analyze_data():
    data = request.get_json() # JSON 데이터 받기
    station_name = data.get('stationName')
    date = data.get('date')
    time = data.get('time')
    stationLine = data.get('stationLine')
    rows=[date,station_name,time,stationLine]
    return json.dumps(rows, ensure_ascii=False).encode('utf8')

if __name__ == '__main__':
    app.run(host="127.0.0.1", port=5000, debug=True)