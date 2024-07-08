"""
 ## Desc : chat bot service api 
## Author : harusizakc
## update: 
    * 2024.06.28 by J.park : service update
        - news 페이지 생성 및 초기 연결
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import pymysql
from typing import List
from fastapi.responses import JSONResponse

router = APIRouter()

# 데이터베이스 연결 설정
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'qwer1234',
    'db': 'news_analysis_db',
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}

class NewsItem(BaseModel):
    date: str
    title: str
    link: str
    content: str
    newContent: str
    translated_content: str
    # emotion_sadness: float
    # emotion_joy: float
    # emotion_love: float
    # emotion_anger: float
    # emotion_fear: float
    # emotion_surprise: float
    sadness: float
    joy: float
    love: float
    anger: float
    fear: float
    surprise: float

@router.get("/news", response_model=List[NewsItem])
async def get_news():
    print("뉴스 실행됨ㅋㅋ")
    try:
        connection = pymysql.connect(**DB_CONFIG)
        with connection.cursor() as cursor:
            sql = "SELECT * FROM translated_news"
            cursor.execute(sql)
            result = cursor.fetchall()
        
        # 결과를 NewsItem 객체 리스트로 변환
        news_items = [NewsItem(**item) for item in result]
        print("*******************************")
        print(news_items)
        print("*******************************")
        # JSONResponse로 반환
        return JSONResponse(content=[item.dict() for item in news_items])
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        connection.close()