"""
---
## 📌 Project : 하루시작 프로젝트 SERVER 📌🔸🟦✅🆕🉐
## 📌 Description : 
    🔸 Flask 에서 앱으로 출력 하는 기능을 테스트 한다. 
## 📌 Author : Forrest DongGeun Park 
## 📌 Date : 2024.05.31 ~
## 📌 Detail : 
    🔸 http://localhost:8000/subway?
## 📌 Updates: 
    2024.07.01 J.park : flask 서버를 FastApi로 변경
         
---
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import joblib
import os
import sys
import pandas as pd
from flask import jsonify
from fastapi.responses import JSONResponse
# 상위 디렉토리 경로 추가
# 현재 파일의 디렉토리
current_dir = os.path.dirname(os.path.abspath(__file__))

# Server 디렉토리
server_dir = os.path.dirname(current_dir)

# DataAnalysis 디렉토리 (parent_dir로 사용)
parent_dir = os.path.dirname(server_dir)


# 시스템 경로에 추가
sys.path.append(parent_dir)

from Module.Functions import Service

router = APIRouter()

# 통신시 받아온 변수를 검증함 (BaseModel)
class SubwayRequest(BaseModel):
    stationName: str
    date: str
    time: str
    stationLine: str




@router.get("/")
async def read_root():
    return {"message": "Welcome to subway API"}

@router.post("/subwayRide")
async def predict_subway(request: SubwayRequest):
    station_name = request.stationName
    date = request.date
    time = request.time
    stationLine = request.stationLine
    print("#####**********************************")
    print(station_name,date,time,stationLine)
    print("#####**********************************")

    station_code = Service.station_name_to_code(int(stationLine), station_name.replace(" ", ""))
    print(station_code)
    month_number, week_number, is_holi, dayname_code = Service.date_string_to_MonthWeekHolyDayname(date)
    is주말 = True if dayname_code == 6 or dayname_code == 5 else False

    배차_data_path = os.path.join(parent_dir, "Data2", "지하철배차시간데이터", f"{stationLine}호선배차.csv")
    table_배차 = pd.read_csv(배차_data_path)
    target_row = table_배차[table_배차['역사코드'] == station_code]
    selected_index = 'SAT' if is주말 else 'DAY'
    target_row = target_row[target_row['주중주말'] == selected_index]
    시간별배차정보 = list(target_row.iloc[:,3:].to_numpy())[0]

    위도경도_data_path = os.path.join(parent_dir, "Data2", 'seoul_subway_latlon_zenzen.csv')
    latlng = pd.read_csv(위도경도_data_path)
    a = latlng[latlng['역사코드'] == station_code].to_numpy()[0][-2:]
    위도, 경도 = a[0], a[1]

    rows = [month_number, week_number, is_holi, dayname_code, station_code, not is주말, is주말, 위도, 경도, *시간별배차정보]

    try:
        model_path = os.path.join(parent_dir, "MLModels", f"knn_regressor_subway23_0_{stationLine}호선_승차.h5")
        knn_regressor_승차 = joblib.load(model_path)

        pre = knn_regressor_승차.predict([rows])
        
        target_column = ['05시인원', '06시인원', '07시인원',
        '08시인원', '09시인원', '10시인원', '11시인원', '12시인원', '13시인원', '14시인원', '15시인원',
        '16시인원', '17시인원', '18시인원', '19시인원', '20시인원', '21시인원', '22시인원', '23시인원',
        '24시인원']

        result = pre.tolist()[0]
        response = {column: value for column, value in zip(target_column, result)}
        
        return  response#SubwayResponse(시인원=result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/subwayAlighting")
async def predict_subway_alighting(request: SubwayRequest):
    data = request
    station_name = request.stationName
    date = request.date
    time = request.time
    stationLine = request.stationLine

    # if not all([station_name, date, time, stationLine]):
    #     raise HTTPException(status_code=400, detail="Missing required fields")

    station_code = Service.station_name_to_code(int(stationLine), station_name.replace(" ", ""))
    print('필요정보:', *['월', '주차', '공휴일', '요일', '역사코드', '주중', '주말', '위도', '경도', ' 배차'], sep='\t')

    month_number, week_number, is_holi, dayname_code = Service.date_string_to_MonthWeekHolyDayname(date)
    is주말 = True if dayname_code == 6 or dayname_code == 5 else False

    배차_data_path = os.path.join(parent_dir, "Data2", "지하철배차시간데이터", f"{stationLine}호선배차.csv")
    table_배차 = pd.read_csv(배차_data_path)

    target_row = table_배차[table_배차['역사코드'] == station_code]
    selected_index = 'SAT' if is주말 else 'DAY'
    target_row = target_row[target_row['주중주말'] == selected_index]
    시간별배차정보 = list(target_row.iloc[:, 3:].to_numpy())[0]

    위도경도_data_path = os.path.join(parent_dir, "Data2", 'seoul_subway_latlon_zenzen.csv')
    latlng = pd.read_csv(위도경도_data_path)
    a = latlng[latlng['역사코드'] == station_code].to_numpy()[0][-2:]
    위도, 경도 = a[0], a[1]
    rows = [month_number, week_number, is_holi, dayname_code, station_code, not is주말, is주말, 위도, 경도, *시간별배차정보]

    print('입력정보:', *rows, sep='\t')

    try:
        model_path = os.path.join(parent_dir, "MLModels", f"knn_regressor_subway23_0_{stationLine}호선_하차.h5")
        knn_regressor_하차 = joblib.load(model_path)

        exam = [[1, 1, 1, 2, 2729, True, False, 37.54040751726388,
                 127.06920291650827, 2.5, 7.5, 12.0, 19.0, 15.5, 11.0, 10.0, 10.0,
                 10.0, 10.0, 10.0, 10.0, 10.5, 16.5, 14.5, 10.5, 9.5, 8.5, 7.0, 0.5]]
        print(f"row len: {len(rows)} ,example len : {len(exam[0])}")

        pre = knn_regressor_하차.predict([rows])

        target_column = ['05시인원', '06시인원', '07시인원',
                         '08시인원', '09시인원', '10시인원', '11시인원', '12시인원', '13시인원', '14시인원', '15시인원',
                         '16시인원', '17시인원', '18시인원', '19시인원', '20시인원', '21시인원', '22시인원', '23시인원',
                         '24시인원']
        print(pre)
        result = pre.tolist()
        print("예측결과: ", result)
        response = {column: value for column, value in zip(target_column, result[0])}
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))