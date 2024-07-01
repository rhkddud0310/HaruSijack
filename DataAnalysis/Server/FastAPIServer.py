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

    * 2024.07.01 by J.park :
        - subway 라우트 구성         
"""

def CrawlInstalls():
    import subprocess,sys
    # pip가 없으면 pip를 설치한다.
    try:import pip
    except ImportError:
        print("Install pip for python3")
        subprocess.call(['sudo', 'apt-get', 'install', 'python3-pip'])
    try:import selenium        
    except ModuleNotFoundError:
        print("Install Selenium in python3")
        subprocess.call([sys.executable, "-m", "pip", "install", 'selenium'])
    finally:import selenium 

    try:import webdriver_manager
    except ModuleNotFoundError: 
        print("Install webdriver_manager")
        subprocess.call([sys.executable, "-m", "pip", "install", 'webdriver_manager'])
    finally:import webdriver_manager
# CrawlInstalls()

def NLPInstalls():
    import subprocess,sys
    
    # pip가 없으면 pip를 설치
    try:import pip
    except ImportError:
        print("Install pip for python3")
        subprocess.call(['sudo', 'apt-get', 'install', 'python3-pip'])
    
    # tweepy 없으면 tweepy 설치
    try:import tweepy        
    except ModuleNotFoundError:
        print("Install tweepy")
        subprocess.call([sys.executable, "-m", "pip", "install", 'tweepy==3.10.0'])
    finally:import tweepy 
    
    # konlpy 없으면 konlpy 설치
    try:import konlpy
    except ModuleNotFoundError: 
        print("Install konlpy")
        subprocess.call([sys.executable, "-m", "pip", "install", 'konlpy'])
    finally:import konlpy
    
    # eunjeon 없으면 eunjeon 설치
    try:import eunjeon
    except ModuleNotFoundError: 
        print("Install eunjeon : eunjeon")
        subprocess.call([sys.executable, "-m", "pip", "install", 'eunjeon'])
    finally:import konlpy
    
    # datasets 없으면 datasets를 설치
    try:import datasets
    except ModuleNotFoundError: 
        print("Install eunjeon : datasets")
        subprocess.call([sys.executable, "-m", "pip", "install", 'datasets'])
    finally:import datasets
    
    # pytorch 없으면 pytorch 설치
    try:import torch
    except ModuleNotFoundError: 
        print("Install eunjeon : pytorch")
        subprocess.call([sys.executable, "-m", "pip", "install", 'pytorch'])
    finally:import torch
    
    # transformers 없으면 transformers 설치
    try:import transformers
    except ModuleNotFoundError: 
        print("Install eunjeon : transformers")
        subprocess.call([sys.executable, "-m", "pip", "install", 'transformers'])
    finally:import transformers
# NLPInstalls()


def ServerInstalls():
    import subprocess,sys
    try:import pip
    except ImportError:
        print("Install pip for python3")
        subprocess.call(['sudo', 'apt-get', 'install', 'python3-pip'])
    finally:import tweepy 
    
    ##  items 설치
    try:import items
    except ModuleNotFoundError:
        print("Install pip for items")
        subprocess.call([sys.executable, "-m", "pip", "install", 'items'])
        
    finally:import tweepy 
    
    ##  fasapi 설치
    try:import fastapi
    except ModuleNotFoundError:
        print("Install pip for fastapi")

        subprocess.call([sys.executable, "-m", "pip", "install", 'fastapi'])
    finally:import tweepy 
    
    # pymysql 없으면 pymysql 설치
    try:import pymysql        
    except ModuleNotFoundError:
        print("Install pymysql")
        subprocess.call([sys.executable, "-m", "pip", "install", 'pymysql'])
    finally:import tweepy 
ServerInstalls()


from fastapi import FastAPI
import pymysql
import sys
import os


# 현재 스크립트의 디렉토리
current_dir = os.path.dirname(os.path.abspath(__file__))

# DataAnalysis 디렉토리
data_analysis_dir = os.path.dirname(current_dir)

# HaruSijack 디렉토리 (프로젝트 루트)
project_root = os.path.dirname(data_analysis_dir)


# 시스템 경로에 추가
sys.path.append(data_analysis_dir)
# sys.path.append(project_root)
from routers import subway
from routers import chatbot
# from routers import news
# from DataAnalysis.Module.Functions import Service

app = FastAPI()

# router 사용 
app.include_router(subway.router, prefix="/subway", tags=["subway"])
# app.include_router(news.router, prefix="/news", tags=["news"])
app.include_router(chatbot.router, prefix="/chat-kakao", tags=["chat-kakao"])

#서버실행 test
@app.get("/")
async def root():
    return {"message": "서버가 실행 중입니다!"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0",port= 8000)
    
# uvicorn FastAPIServer:app --reload