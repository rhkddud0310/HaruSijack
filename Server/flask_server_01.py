"""
## Projectr : 하루시작 프로젝트 Flask Server 02 (출력 )
## Description : 
    - Flask 에서 앱으로 출력 하는 기능을 테스트 한다. 
## Author : Forrest DongGeun Park 
## Date : 2024.05.31 ~
## Detail : 
    - http://localhost:5000/subway?
## Update: 
    * 2024.06.02 pdg : Flask server
    * 2024.06.07 pdg : model 저장
    * 2024.06.10 pdg  : API 로  app 에 메세지 출력
        -  서버에서 앱에 뿌려 주는 json 의 형식은 해당역의 시간대별 output 예측값ㄷ이다. 

"""


from flask import Flask, jsonify, request
from flask_cors import CORS
import json ,pymysql,joblib 

app = Flask(__name__) # 난 flask 서버야!! 
app.config['JSON_AS_ASCII'] = False 


# CORS(app)  # 모든 출처에서 접근할 수 있도록 설정
## /iris면 여기로 와라!! 
@app.route("/subway")
def subway():
    knn_regressor_승차 = joblib.load("MLModels/knn_regressor_line7_승차.h5")
    pre = knn_regressor_승차.predict(
        [[
            1, 1, 1, 2, 2729, True, False, 37.54040751726388,
        127.06920291650827, 2.5, 7.5, 12.0, 19.0, 15.5, 11.0, 10.0, 10.0,
        10.0, 10.0, 10.0, 10.0, 10.5, 16.5, 14.5, 10.5, 9.5, 8.5, 7.0, 0.5
            
        ]]
    )
    target_column=['05시인원', '06시인원', '07시인원',
    '08시인원', '09시인원', '10시인원', '11시인원', '12시인원', '13시인원', '14시인원', '15시인원',
    '16시인원', '17시인원', '18시인원', '19시인원', '20시인원', '21시인원', '22시인원', '23시인원',
    '24시인원']
    print(pre)
    result = json.dumps(pre, ensure_ascii=False).encode('utf8') # dump 는 글자 하나씩
    
    return result#jsonify([{'result': result}])
