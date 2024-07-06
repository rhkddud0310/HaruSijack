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
    id: int
    newContent: str
    translated_content: str
    sadness: float
    joy: float
    love: float
    anger: float
    fear: float
    surprise: float

@router.get("/news", response_model=List[NewsItem])
async def get_news():
    try:
        connection = pymysql.connect(**DB_CONFIG)
        with connection.cursor() as cursor:
            sql = "SELECT * FROM translated_news"
            cursor.execute(sql)
            result = cursor.fetchall()
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        connection.close()