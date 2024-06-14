"""
# Projectr : 하루시작 지하철 혼잡도 분석
### Description : Multi Processing을 이용한 NAVER News Articles 본문 수집
### Author : Zen Den
### Date : 2024. 06. 12. (Wed) ~
### Detail : 
### Update: 
- 2024.06.12. (Wed) K.Zen : Multi Processing으로 다량의 Link에 대한 본문 수집하기 (현재 Test 중입니다.)
"""

# Import Library Package
## Basic
import pandas as pd, warnings; warnings.filterwarnings('ignore')

## File System
import os
from datetime import datetime

## Crawling
from bs4 import BeautifulSoup
import time
from tqdm import tqdm

from multiprocessing import Pool

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By

## Bag of Words (BoW)
from konlpy.tag import Okt
import nltk # Natural Language Toolkit
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from collections import Counter


# Chrome Browser와 Chrome Driver Version 확인
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('headless')  # Run chrome browser in the background
chrome_options.add_argument('window-size=1920x1080')  # Chrome Browser Window Size

"""
    본문 수집 함수 작성:
    - 주어진 Link에서 기사 본문을 수집하고 ScreenShot을 저장합니다.
    - ScreenShot 저장 경로 설정, File Name 중복 처리 등 추가 기능을 포함합니다.

    함수 인자 전달:
    - fetch_article_content 함수는 이제 하나의 인자 args를 받습니다.
        이 인자는 Link와 DataFrame의 Tuple입니다.
    - link, df = args를 통해 Tuple에서 Link와 DataFrame을 추출합니다.
"""
def fetch_article_content (args) :
    """
    주어진 URL에서 기사의 본문을 수집하는 함수
    """
    link, df = args
    try :
        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options = chrome_options)
        driver.get(link)

        # **************************************************************************
        # 기본 Path 설정
        today = datetime.now().strftime('%Y%m%d')   # 오늘 날짜 가져오기
        base_path = f"Scrapy_Crawling/Data/ScreenShot/By_Press/{today}"

        ## By_Press 폴더 생성
        os.makedirs(base_path, exist_ok = True)

        # 동일한 By_Press/today Folder가 존재하는지 확인하고, 존재한다면 하위에 새로운 Folder 생성
        new_path = base_path
        while os.path.exists(new_path) :
            new_path = os.path.join(base_path, str(len(os.listdir(base_path)) + 1)) # index는 폴더 내 파일 개수 + 1로 설정
        
        # 새로운 Folder 생성
        os.makedirs(new_path, exist_ok = True)

        # 기본 File Name 설정
        base_filename = df[df['Link'] == link]['Title'].values[0]
        extension = ".png"
        name_index = 1  # File Name에 추가될 숫자
        new_filename = base_filename + extension

        # File Path 생성
        screenshot_name = os.path.join(new_path, new_filename)

        # 동일한 File Name이 존재하는지 확인하고, 존재한다면 새로운 File Name 생성
        while os.path.exists(screenshot_name) :
            new_filename = f"{base_filename}_{name_index}{extension}"
            screenshot_name = os.path.join(new_path, new_filename)
            name_index += 1

        # ScreenShot 촬영 전에 시간 두기. (Loading이 느릴수도 있으므로...)
        time.sleep(3)
        
        # Browser 최대화
        driver.maximize_window()
        
        # 현재 화면 Capture하기
        driver.save_screenshot(screenshot_name)
        # **************************************************************************

        html = driver.page_source
        driver.quit()  # Browser 종료 (모든 Tab 종료)
        article_soup = BeautifulSoup(html, "html.parser")
        content = article_soup.select_one("#contents")
        if content :
            # 공백과 HTML Tag 제거
            text = ' '.join(content.text.split())
            return text
        
        else :
            return None
        
    except Exception as e :
        print(f"Error fetching {link}: {e}")
        return None

"""
    Multiprocessing을 사용하여 본문 수집:
    - args = [(link, df) for link in links]: 모든 Link와 DataFrame을 함께 전달할 Tuple List를 생성합니다.
    - Pool(processes = 4): 4개의 Process를 가진 Pool을 생성합니다.
    - pool.imap(fetch_article_content, args): 각 Process에 Tuple을 전달하여 병렬로 작업을 수행합니다.
"""
def main () :
    # DataFrame Load
    df = pd.read_csv("Scrapy_Crawling/Data/NAVER_News_List_20240612.csv")

    # 모든 Link 가져오기
    links = df['Link'].tolist()

    # Link와 DataFrame을 함께 전달할 Tuple List 생성
    args = [(link, df) for link in links]

    # ************************************************************************************************
    # Multi Processing을 사용하여 본문 수집
    pool = Pool(processes = 4)  # 4개의 Process를 가진 Pool을 생성
    results = list(
        tqdm(
            pool.imap(fetch_article_content, args),
            total = len(links),
            desc = "Crawling 진행 중",
            unit = "Link"
        )
    )
    pool.close()  # 작업이 끝난 후 Pool을 닫음
    pool.join()  # 모든 프로세스가 끝날 때까지 기다림
    # ************************************************************************************************

    # 빈 문서가 있는지 확인
    articles = [article for article in results if article and article.strip()]

    # 기사 내용이 제대로 수집되었는지 확인
    for i, article in enumerate(articles) :
        print(f"기사 {i + 1}: {article[:100]}...")  # 기사 내용 앞부분만 출력
    
    # NLTK를 이용하여 불용어 제거, 단어 토큰화, 표제어 추출
    ## 한국어 불용어 모음집 불러오기
    stopword_list = pd.read_csv("Scrapy_Crawling/Data/stopword.txt", header = None)
    stopword_list[0] = stopword_list[0].apply(lambda x: x.strip())
    korean_stopwords = stopword_list[0].to_numpy()

    nltk.download('punkt')
    nltk.download('wordnet')
    lemmatizer = WordNetLemmatizer()
    tokenized_articles = []
    for article in tqdm(articles, desc = "Text 처리 중", unit = "기사") :
        tokens = word_tokenize(article)
        tokens = [lemmatizer.lemmatize(word.lower()) for word in tokens if word.isalnum() and word.lower() not in korean_stopwords]
        tokenized_articles.append(' '.join(tokens))

    # 빈 문서가 있는지 다시 확인
    tokenized_articles = [article for article in tokenized_articles if article.strip()]

    # 각 기사별 Keyword 추출 (빈도 높은 단어)
    keywords = []
    for article in tokenized_articles :
        word_counts = Counter(article.split())
        common_words = word_counts.most_common(10)  # 상위 10개 단어 추출
        keywords.append([word for word, freq in common_words])

    # Keyword 확인
    for i, kw in enumerate(keywords) :
        print(f"기사 {i + 1} 키워드: {kw}")

if __name__ == "__main__" :
    main()