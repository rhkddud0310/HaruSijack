"""
---
## 📌 Project : 하루시작 프로젝트 SERVER 📌🔸🟦✅🆕🉐
## 📌 Description : 
    🔸 Flask 에서 앱으로 출력 하는 기능을 테스트 한다. 
## 📌 Author : Forrest DongGeun Park 
## 📌 Date : 2024.05.31 ~
## 📌 Detail : 
    🔸 http://localhost:5000/subway?
## 📌 Updates: 
    🟦 2024.06.02 pdg : Flask server
    🟦 2024.06.07 pdg : model 저장
    🟦 2024.06.10 pdg  : API 로  app 에 메세지 출력
        ✅  서버에서 앱에 뿌려 주는 json 의 형식은 해당역의 시간대별 output 예측값ㄷ이다. 
        ✅  앱에서 받은 정보를 통해 knn 예측하여 api json 으로 뿌려주는것 만들었음. 
    🟦 2024.06.11 pdg : 효율적인 서버 운용및 유지보수를 위한 폴더 재배치
        ✅ Server 동작을 위한 import setting 변경 
    🟦 2024.06.12 pdg : 서비스 문제 해결(오늘 해야할것 . )
        🆕 환승역에서는 검색이 안되는 이유 찾기
        🆕 하차모델 적용 하기
        🆕 인풋을 데이터 포맷에 맞게 반환해주는 함수 만들기 <- 하찰모델 만들어 적용
    2024.06.13 pdg : 통합데이터 정제 함수 만들기
        ✅ data_preprocessing_toAnalysis 만듬. 
    2024.06.22 pdg : 모든 호선에 대한 머신러닝 모델 적용 
        - match case 사용 aws 에 맞춤 
         
---
"""


from flask import Flask, jsonify, request
from flask_cors import CORS
import json ,pymysql,joblib 
import warnings ; warnings.filterwarnings('ignore')
# 함수 사용하기 위한 나의 모듈위치 추적 
import sys
import os
# 현재 파일의 디렉토리 경로를 기준으로 상위 폴더 경로를 가져온다.
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# 상위 폴더 경로를 sys.path에 추가한다.
sys.path.append(parent_dir)

# 이제 상위 폴더에 있는 Module 폴더 안의 Functions 모듈을 import한다.
from Module.Functions import Service
# my_functions 모듈의 함수를 사용할 수 있습니다.
app = Flask(__name__) # 난 flask 서버야!! 
app.config['JSON_AS_ASCII'] = False 


# CORS(app)  # 모든 출처에서 접근할 수 있도록 설정
## 해당일의 승차인원 정보
@app.route("/subway", methods=['POST'])
def subway():
    
    data = request.get_json() # JSON 데이터 받기
    station_name = data.get('stationName')
    date = data.get('date')
    time = data.get('time')
    stationLine = data.get('stationLine')
    ## 월 정보 
    station_code= Service.station_name_to_code(int(stationLine),station_name.replace(" ",""))
    print('필요정보:',*['월', '주차', '공휴일', '요일', '역사코드', '주중', '주말','위도','경도',' 배차 '],sep='\t')
    
    
    # 월, 주, 휴일여부, 요일코드 추출 
    month_number, week_number, is_holi, dayname_code = Service.date_string_to_MonthWeekHolyDayname(date)
    # 주말 여부 ( bool )
    is주말= True if dayname_code== 6 or dayname_code == 5 else False 
    
    ## 해당일자의 배차 정보 조회 
    import pandas as pd 
    배차_data_path = os.path.join(parent_dir, "Data", "지하철배차시간데이터", f"{stationLine}호선배차.csv")
    table_배차 = pd.read_csv(배차_data_path)
    target_row = table_배차[table_배차['역사코드']==station_code]
    selected_index = 'SAT' if is주말 else 'DAY'
    target_row = target_row[target_row['주중주말'] == selected_index]
    시간별배차정보 = list(target_row.iloc[:,3:].to_numpy())[0]
    
    ## 위도 경도 정보 뽑기 
    위도경도_data_path = os.path.join(parent_dir, "Data", 'seoul_subway_latlon_zenzen.csv')
    latlng=pd.read_csv(위도경도_data_path)
    a= latlng[latlng['역사코드']==station_code].to_numpy()[0][-2:]#['latitude','longitude']
    위도, 경도 = a[0],a[1]
    rows=[month_number, week_number,is_holi,dayname_code,station_code,not is주말,is주말,위도,경도,*시간별배차정보]
    print('입력정보:',*rows,sep='\t')

    try:
        ### machine learning model case 
        match stationLine: 
            case stationLine if stationLine == 1:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_1호선_승차.h5")        
            case stationLine if stationLine == 2:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_2호선_승차.h5")        
            case stationLine if stationLine == 3:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_3호선_승차.h5")        
            case stationLine if stationLine == 4:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_4호선_승차.h5")        
            case stationLine if stationLine == 5:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_5호선_승차.h5")        
            case stationLine if stationLine == 6:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_6호선_승차.h5")        
            case stationLine if stationLine == 7:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_line7_승차.h5")        
            case stationLine if stationLine == 8:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_8호선_승차.h5")        
        #지하철 승하차 모델 path 
        
        # model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_line7_승차.h5")

        knn_regressor_승차 = joblib.load(model_path)
        
        exam = [[
                1, 1, 1, 2, 2729, True, False, 37.54040751726388,
            127.06920291650827, 2.5, 7.5, 12.0, 19.0, 15.5, 11.0, 10.0, 10.0,
            10.0, 10.0, 10.0, 10.0, 10.5, 16.5, 14.5, 10.5, 9.5, 8.5, 7.0, 0.5
            ]]
        print(f"row len: {len(rows)} ,example len : {len(exam[0])}")

        pre = knn_regressor_승차.predict([rows])
        
        target_column=['05시인원', '06시인원', '07시인원',
        '08시인원', '09시인원', '10시인원', '11시인원', '12시인원', '13시인원', '14시인원', '15시인원',
        '16시인원', '17시인원', '18시인원', '19시인원', '20시인원', '21시인원', '22시인원', '23시인원',
        '24시인원']
        # result = json.dumps(list(pre), ensure_ascii=False).encode('utf8') # dump 는 글자 하나씩
        print(pre)
        result = pre.tolist()
        print("예측결과: ",result)
        response = {column: value for column, value in zip(target_column, result[0])}
        return jsonify(response)
        return result#jsonify([{'result': result}])
    except Exception as e:
        return jsonify({'error': str(e)})
    
    
@app.route('/analyze', methods=['POST'])
def analyze_data():
    data = request.get_json() # JSON 데이터 받기
    station_name = data.get('stationName')
    date = data.get('date')
    time = data.get('time')
    stationLine = data.get('stationLine')
    rows=[date,station_name,time,stationLine]
    return json.dumps(rows, ensure_ascii=False).encode('utf8')

# 해당일의 하차인원 정보
@app.route("/subwayAlighting", methods=['POST'])
def subwayAlighting():
    
    data = request.get_json() # JSON 데이터 받기
    station_name = data.get('stationName')
    date = data.get('date')
    time = data.get('time')
    stationLine = data.get('stationLine')
    
    
    ## 월 정보 
    station_code= Service.station_name_to_code(int(stationLine),station_name.replace(" ",""))
    print('필요정보:',*['월', '주차', '공휴일', '요일', '역사코드', '주중', '주말','위도','경도',' 배차 '],sep='\t')
    
    
    
    # 월, 주, 휴일여부, 요일코드 추출 
    month_number, week_number, is_holi, dayname_code = Service.date_string_to_MonthWeekHolyDayname(date)
    # 주말 여부 ( bool )
    is주말= True if dayname_code== 6 or dayname_code == 5 else False 
    
    ## 해당일자의 배차 정보 조회 
    import pandas as pd 
    배차_data_path = os.path.join(parent_dir, "Data", "지하철배차시간데이터", f"{stationLine}호선배차.csv")
    table_배차 = pd.read_csv(배차_data_path)
    
    target_row = table_배차[table_배차['역사코드']==station_code]
    selected_index = 'SAT' if is주말 else 'DAY'
    target_row = target_row[target_row['주중주말'] == selected_index]
    시간별배차정보 = list(target_row.iloc[:,3:].to_numpy())[0]
    
    ## 위도 경도 정보 뽑기 
    위도경도_data_path = os.path.join(parent_dir, "Data", 'seoul_subway_latlon_zenzen.csv')
    latlng=pd.read_csv(위도경도_data_path)
    a= latlng[latlng['역사코드']==station_code].to_numpy()[0][-2:]#['latitude','longitude']
    위도, 경도 = a[0],a[1]
    rows=[month_number, week_number,is_holi,dayname_code,station_code,not is주말,is주말,위도,경도,*시간별배차정보]
    
    print('입력정보:',*rows,sep='\t')

    try:
        match stationLine: 
            case stationLine if stationLine == 1:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_1호선_하차.h5")        
            case stationLine if stationLine == 2:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_2호선_하차.h5")        
            case stationLine if stationLine == 3:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_3호선_하차.h5")        
            case stationLine if stationLine == 4:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_4호선_하차.h5")        
            case stationLine if stationLine == 5:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_5호선_하차.h5")        
            case stationLine if stationLine == 6:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_6호선_하차.h5")        
            case stationLine if stationLine == 7:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_line7_하차.h5")        
            case stationLine if stationLine == 8:
                model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_subway23_0_8호선_하차.h5")    
        
        #지하철 승하차 모델 path 
        model_path = os.path.join(parent_dir, "MLModels", "knn_regressor_line7_하차.h5")

        knn_regressor_하차 = joblib.load(model_path)
        
        exam = [[
                1, 1, 1, 2, 2729, True, False, 37.54040751726388,
            127.06920291650827, 2.5, 7.5, 12.0, 19.0, 15.5, 11.0, 10.0, 10.0,
            10.0, 10.0, 10.0, 10.0, 10.5, 16.5, 14.5, 10.5, 9.5, 8.5, 7.0, 0.5
            ]]
        print(f"row len: {len(rows)} ,example len : {len(exam[0])}")

        pre = knn_regressor_하차.predict([rows])
        
        target_column=['05시인원', '06시인원', '07시인원',
        '08시인원', '09시인원', '10시인원', '11시인원', '12시인원', '13시인원', '14시인원', '15시인원',
        '16시인원', '17시인원', '18시인원', '19시인원', '20시인원', '21시인원', '22시인원', '23시인원',
        '24시인원']
        # result = json.dumps(list(pre), ensure_ascii=False).encode('utf8') # dump 는 글자 하나씩
        print(pre)
        result = pre.tolist()
        print("예측결과: ",result)
        response = {column: value for column, value in zip(target_column, result[0])}
        return jsonify(response)
        return result#jsonify([{'result': result}])
    except Exception as e:
        return jsonify({'error': str(e)})


@app.route('/chat-kakao', methods=['POST'])
def chat_kakao():
    print("request.json : ",request.json)
    response_to_kakao = format_response("반가워!")
    return response_to_kakao

def format_response(resp):
    data = {
        "version": "2.0",
        "template" : {
            "outputs" : [
                {
                    "simpleText" : {
                        "text" : resp
                    }
                }
            ]
        }
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True) # 서버구동
    