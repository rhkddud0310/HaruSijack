# -*- coding: utf-8 -*-
"""
# Projectr : 하루시작 지하철 혼잡도 분석
### Description : NAVER News - 언론사별 랭킹 뉴스를 웹크롤링 후 BERT Model을 활용한 오늘의 뉴스 추천하기
### Author : Zen Den
### Date : 2024. 06. 15. (Sat) ~
### Detail :
  - Crawling 평균 소요시간
    - 언론사별 랭킹뉴스의 언론사명, Title, Link: 1분 40초
    - 뉴스 기사의 본문: 11분 10초

  - 자연어 처리 평균 소요시간
    - 뉴스 기사 본문의 Keyword 추출: 2분
    - 뉴스 기사 본문의 Embedding 처리: 2분 20초

  > (1) 환경 설정 및 라이브러리 설치
  - 웹 크롤링을 위한 requests와 BeautifulSoup, Selenium
  - 데이터 처리를 위한 pandas
  - 텍스트 처리를 위한 nltk
  - 딥러닝 모델인 BERT를 활용하기 위한 transformers와 torch
  - 자연어 처리 위한 sklearn

  > (2) Web Crawling
  - 네이버 뉴스 페이지를 요청하고, BeautifulSoup으로 HTML 파싱
  - 각 언론사별로 상위 5개 뉴스 기사 제목 및 Link 추출

  > (3) Keyword 추출
  - 각 뉴스 기사 본문을 가져와서 빈도수 높은 단어 추출
  - 불용어 제거 및 형태소 분석을 통해 주요 Keyword 도출

  > (4) 뉴스 추천 시스템 구축
  - BERT Model을 활용하여 각 뉴스 기사 Embedding 생성
  - 코사인 유사도를 사용하여 주요 Keyword와 유사한 뉴스 기사 추천
### Update:
  - 2024.06.14. (Fri) G.Zen : Deep Learning(BERT Model, 코사인 유사도)을 활용하여 뉴스 추천 시스템 구현하기.
  - 2024.06.15. (Sat) G.Zen : 추천된 뉴스의 Title과 Link를 JSON Type으로 전송하기.
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

import os
print("현재 작업 디렉토리:", os.getcwd())
# Import Library Package
## Flask Server
from flask import Flask, request, jsonify

## Basic
import pandas as pd, numpy as np

## Crawling
import requests # 인터넷에서 Data를 가져오기 위한 Library (웹페이지에 접속하고 HTML 코드를 가져오기 위해 사용)
from bs4 import BeautifulSoup # 웹 페이지 내용을 분석하기 위한 Library (가져온 HTML 코드에서 우리가 필요한 정보를 추출하기 위해 사용)

import time # 대기 시간을 추가하기 위한 Library (요청 사이에 랜덤한 시간을 기다리기 위해 사용)
import random # Random한 대기 시간을 만들기 위한 Library
from tqdm import tqdm # Crawling 진행 상황을 체크하기 위한 Module (진행 상황을 시각적으로 보여주기 위해 사용)

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

## Bag of Words (BoW)
import nltk # Natural Language Toolkit (자연어 처리를 위해 사용)
from konlpy.tag import Okt
from collections import Counter # 단어의 빈도를 계산하기 위해 사용

### 1. nltk Data Download
nltk.download('punkt')

### 2. 한국어 불용어 사전
# *************************************************************************
## 한국어 불용어 모음집 불러오기
stopword_list = pd.read_csv("../Data/updated_stopword.txt", header = None)
# *************************************************************************
stopword_list[0] = stopword_list[0].apply(lambda x: x.strip())
stopwords = stopword_list[0].to_numpy()

## Deep Learning
import torch
from transformers import BertModel, BertTokenizer
from sklearn.metrics.pairwise import cosine_similarity

# ****************************************************************************************************************************************************************

app = Flask(__name__)
# ***********************************************
app.config['JSON_AS_ASCII'] = False # for utf-8
# ***********************************************

# # 1. NAVER News Web Crawling
# ## 1-1. 언론사별 랭킹뉴스 Crawling 함수 정의
# def get_news_links_by_press (url) :
#   """
#     headers:
#     - 나는 bot이 아니고 사람임을 증명하는 부분이다.
#       - 사용하지 않을 시 언론사에서 웹크롤링을 막을 수 있으니 주의할 것!
#   """
#   headers = {
#     "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
#   }
#   response = requests.get(url, headers = headers) # url(페이지)에 접속
#   soup = BeautifulSoup(response.content, 'html.parser') # HTML 코드를 파싱(분석)하여 soup 객체에 저장
  
#   press_data = {}
#   press_sections = soup.select('.rankingnews_box')
  
#   for press_section in tqdm(press_sections, desc = "언론사별 뉴스 Crawling") :
#     press_name = press_section.select_one('.rankingnews_name').get_text(strip = True)
#     news_links = set()  # 중복 제거를 위한 set 사용
#     for item in press_section.select('li a') :
#       title = item.get_text(strip = True)
#       link = item['href']
#       if title and link and "동영상" not in title :  # Title이 존재하고 "동영상"이 포함되지 않은 경우에만 추가
#         news_links.add((title, link))
#     press_data[press_name] = list(news_links)[:5]  # 다시 list로 변환 후 상위 5개만 저장
    
#     # *********************************************
#     # 각 언론사별 뉴스 Crawling 후 대기 시간 추가
#     time.sleep(random.uniform(0.5, 2.0))
#     # *********************************************
  
#   return press_data

# ## 1-2. 언론사별 랭킹뉴스의 Press, Title, Link를 토대로 하는 DataFrame 생성
# base_url = 'https://news.naver.com/main/ranking/popularDay.naver'
# press_news_data = get_news_links_by_press(base_url)

# news_list = []
# for press_name, news_data in press_news_data.items() :
#   for title, link in news_data :
#     news_list.append([press_name, title, link])
# news_df = pd.DataFrame(news_list, columns = ['Press', 'Title', 'Link'])


# # 2. 언론사별 뉴스 기사 본문 Crawling
# ## 2-1. Chrome Browser와 Chrome Driver Version 확인 및 WebDriver 객체 생성
# chrome_options = webdriver.ChromeOptions()
# # ******************************************************
# chrome_options.add_argument('headless') # Run chrome browser in the background
# chrome_options.add_argument('window-size = 1920x1080')  # Chrome Browser Window Size
# # ******************************************************
# driver = webdriver.Chrome(service = Service(ChromeDriverManager().install()), options = chrome_options)

# # 2-2. 언론사별 뉴스 기사 본문 Crawling 함수 정의
# def get_article_text (url) :
#   driver.get(url)
#   html = driver.page_source
#   article_soup = BeautifulSoup(html, "html.parser")
#   content = article_soup.select_one("#contents")
#   if content :
#     # 공백과 HTML Tag 제거
#     text =''.join(content.text.split())
#     # *******************************************
#     # 요청 후 임의의 시간만큼 대기 (Page Loaded)
#     time.sleep(random.uniform(0.5, 2.0))
#     # *******************************************
    
#     return text

# ## 2-3. 뉴스 기사 본문 수집
# content_pbar = tqdm(news_df['Link'], desc = "뉴스 기사 본문 Crawling 진행 중", unit = "Link")
# news_df['content'] = [get_article_text(url) for url in content_pbar]

# ## 2-4. Browser 종료 (모든 Tab 종료)
# driver.quit()


# # 3. 주요 Keyword 추출
# # 3-1. Keyword 추출 함수 정의
# def get_keywords (text, num_keywords = 10) :
#   okt = Okt()
#   tokens = okt.nouns(text)
#   tokens = [word for word in tokens if word not in stopwords and len(word) > 1]
#   return [word for word, freq in Counter(tokens).most_common(num_keywords)]

# # 3-2. 각 언론사별 Keyword 추출
# text_pbar = tqdm(news_df['content'], desc = "Text 처리 중", unit = "기사")
# news_df['keywords'] = [get_keywords(text) for text in text_pbar]


# # 4. News Recommendations System
# ## 4-1. BERT 모델 및 토크나이저 불러오기
# tokenizer = BertTokenizer.from_pretrained('bert-base-multilingual-cased')
# model = BertModel.from_pretrained('bert-base-multilingual-cased')

# """
#     with torch.no_grad():
#     - 블록을 사용하여 모델의 출력을 계산할 때 그래디언트를 저장하지 않도록 했습니다.
#         - 이는 메모리 사용량을 줄이고 성능을 향상시킵니다.
# """
# ## 4-2. 문장 임베딩 생성 함수 정의
# def get_bert_embedding (text) :
#   inputs = tokenizer(
#     text,
#     return_tensors = 'pt',
#     truncation = True,
#     padding = True,
#     max_length = 512
#   )
#   with torch.no_grad() :
#     outputs = model(**inputs)
#   return outputs.last_hidden_state.mean(dim = 1).detach().numpy()

# ## 4-3. 각 뉴스 기사 임베딩 생성
# embed_pbar = tqdm(news_df['content'], desc = "Embedding 처리 중", unit = "text")
# news_df['embedding'] = [get_bert_embedding(text) for text in embed_pbar]

# """
#     keyword_text 생성 시, sum(news_df['keywords'], [])을 사용하여 List의 List를 평탄화한 후 Keyword를 결합합니다.
# """
# ## 4-4. 주요 Keyword 임베딩 생성
# keyword_text = ' '.join(sum(news_df['keywords'], []))
# keyword_embedding = get_bert_embedding(keyword_text)

# """
#     np.vstack(df['embedding'].values:
#     - numpy 배열로 변환하는 부분입니다.
#         - 이는 embeddings 변수를 numpy 배열로 변환하여 코사인 유사도를 계산할 수 있게 합니다.
# """
# ## 4-5. 코사인 유사도 계산 함수 정의
# def recommend_news (df, keyword_embedding, top_n = 10) :
#   embeddings = np.vstack(df['embedding'].values)
#   similarities = cosine_similarity(embeddings, keyword_embedding.reshape(1, -1)).flatten()
#   df['similarity'] = similarities
#   return df.nlargest(top_n, 'similarity')

# ## 4-6. 추천된 뉴스 Data 생성
# recommended_news = recommend_news(news_df, keyword_embedding)

# # """
# #     NumPy 배열을 JSON 직렬화 가능한 형식으로 변환하기 위해 List로 변환하기.
# #       - 'embeddding' Column에 NumPy 배열이 포함되어 있기 때문임.
# #       - 'Object of type ndarray is not JSON serializable' Error 해결 방법 
# # """
# # ## 4-7. # embedding Column(열)을 List로 변환
# # recommended_news['embedding'] = recommended_news['embedding'].apply(lambda x: x.tolist())

# ## 4-7. 필요한 Column만 선택
# columns_to_return = ['Link', 'Press', 'Title', 'content', 'keywords']
# final_recommended_news = recommended_news[columns_to_return]

# ## 4-8. CSV 파일로 저장
# final_recommended_news.to_csv("../Data/recommended_news.csv", index = False)

final_recommended_news = pd.read_csv("../Data/recommended_news.csv")
print("서버 실행됨")
# 5. JSON 형식으로 반환하는 EndPorint 정의
@app.route('/news', methods = ['GET', 'POST'])
def get_recommendations () :
  recommendations = final_recommended_news.to_dict(orient = 'records')
  return jsonify(recommendations)

if __name__ == '__main__' :
  app.run(host = '127.0.0.1', port = 5000, debug = True)