# -*- coding: utf-8 -*-
"""
## Description FAST API SERVER TEST

Author : Forrest D Park, Harusizack team members
Desc: Mysql Fast API 연결 CRude test
Detail : port number 8000

Updates:
    * 2024.06.29 by pdg :
        - server 개설, 뉴스크롤링 서버 와 연동 작업
        - 기존의 flask server 를 라우트로 나누는 작업. 
"""
from fastapi import FastAPI
import pymysql
app = FastAPI()



if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0",port= 8000)
    
# uvicorn students:app --reload