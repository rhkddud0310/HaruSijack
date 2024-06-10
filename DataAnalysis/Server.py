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
        -  앱에서 받은 정보를 통해 knn 예측하여 api json 으로 뿌려주는것 만들었음. 

"""


from flask import Flask, jsonify, request
from flask_cors import CORS
import json ,pymysql,joblib 
from Functions import Service
import warnings ; warnings.filterwarnings('ignore')

app = Flask(__name__) # 난 flask 서버야!! 
app.config['JSON_AS_ASCII'] = False 


# CORS(app)  # 모든 출처에서 접근할 수 있도록 설정
## /iris면 여기로 와라!! ls
@app.route("/subway", methods=['POST'])
def subway():
    data = request.get_json() # JSON 데이터 받기
    station_name = data.get('stationName')
    date = data.get('date')
    time = data.get('time')
    stationLine = data.get('stationLine')
    station_code=Service.station_name_to_code(stationLine,station_name)
    
    ## 월 정보 
 
    station_code= Service.station_name_to_code(int(stationLine),station_name.replace(" ",""))
    print('필요정보:',*['월', '주차', '공휴일', '요일', '역사코드', '주중', '주말',' 배차 '],sep='\t')
    
    ## 배차 정보 조회 
    import pandas as pd 
    table_배차 =pd.read_csv(f"../Data/지하철배차시간데이터/{stationLine}호선배차.csv")
    
    
    
    month_number, week_number,is_holi,dayname_code = Service.date_string_to_MonthWeekHolyDayname(date)
    is주말= True if dayname_code== 6 or dayname_code== 5 else False 
    
    target_row=table_배차[table_배차['역사코드']==station_code]
    selected_index = 'SAT' if is주말 else 'DAY'
    target_row=target_row[target_row['주중주말'] == selected_index]
    시간별배차정보 = list(target_row.iloc[:,3:].to_numpy())[0]
    
    ## 위도 경도 정보 뽑기 
    latlng=pd.read_csv('../Data/seoul_subway_latlon_zenzen.csv')
    a= latlng[latlng['역사코드']==station_code].to_numpy()[0][-2:]#['latitude','longitude']
    위도, 경도 = a[0],a[1]
    
    rows=[month_number, week_number,is_holi,dayname_code,station_code,not is주말,is주말,위도,경도,*시간별배차정보]
    
    print('입력정보:',*rows,sep='\t')

    try:
        model_path = "/Users/forrestdpark/Desktop/PDG/Python_/Project/HaruSijack/Server/knn_regressor_line7_승차.h5"
        knn_regressor_승차 = joblib.load(model_path)
        
        exam = [[
                1, 1, 1, 2, 2729, True, False, 37.54040751726388,
            127.06920291650827, 2.5, 7.5, 12.0, 19.0, 15.5, 11.0, 10.0, 10.0,
            10.0, 10.0, 10.0, 10.0, 10.5, 16.5, 14.5, 10.5, 9.5, 8.5, 7.0, 0.5
                
            ]]
        print(f"row len: {len(rows)}")
        print(f'example len : {len(exam[0])}')
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
if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True) # 서버구동
    