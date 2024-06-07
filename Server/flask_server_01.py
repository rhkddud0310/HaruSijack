"""
## Projectr : 하루시작 프로젝트 Flask Server
## Description : 
    -  Rest api 를 위한 서버 
## Author :  (담당) 
## Date : 2024.05.31 ~
## Detail : 
    - http://localhost:5000/subway?sepalLength=..&...
## Update: 
    -2024.06.02 pdg :  Flask server 

"""
from flask import Flask, jsonify, request
import joblib
from flask_cors import CORS

app = Flask(__name__) # 난 flask 서버야!! 
# CORS(app)  # 모든 출처에서 접근할 수 있도록 설정
## /iris면 여기로 와라!! 
@app.route("/subway")
def subway():
    ## 각 이름에 해당하는 값을 가져옴

    #mlTable, line, station_name, time_passenger
    line=float(request.args.get("line"))
    station_name=float(request.args.get("station_name"))
    time_passenger=float(request.args.get("time_passenger"))


    clf = joblib.load("./rf_subway.h5")
    pre = clf.predict([[line, station_name, time_passenger]])
    print(pre)
    # return jsonify({'result':pre[0][5:]}) # for flutter
    return jsonify([{'result':pre[0][5:]}]) # for swift
    # return "subway Station information"

# @app.route("/iris2")
# def iris2():
#     return "GGGG" 

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True) # 서버구동