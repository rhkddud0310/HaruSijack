
from multiprocessing import Process

def start_get(start, end):
    total = 0
    for i in range(start, end):
        total += i
    print(total)

def naver_newsCrawling(Sid,date=""):
    import pandas as pd
    from bs4 import BeautifulSoup 
    import time, random
    from selenium import webdriver
    from selenium.webdriver.chrome.service import Service
    from webdriver_manager.chrome import ChromeDriverManager
    from selenium.webdriver.common.by import By
    import requests
    import urllib.request as req
    import numpy as np
    from selenium.webdriver.support import expected_conditions as EC
    from selenium.webdriver.support.ui import WebDriverWait
    # Chrome Browser & Chrome Driver Version Check
    chrome_options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(service = Service(ChromeDriverManager().install()), options = chrome_options)
    #사이트 열고 기다림 
    time.sleep(np.random.rand()+0.83)
    # print(soup)
    if date == "":
        import datetime
        today = datetime.date.today()
        formatted_date = today.strftime("%Y%m%d")
        print(formatted_date)
        date = formatted_date
        
    
    link = f'https://news.naver.com/main/list.naver?mode=LS2D&sid2=229&sid1={Sid}&mid=shm&date='
    main_link = link+date
    Main_link = pd.DataFrame({'number':[], 'title':[], 'link':[],'contents':[],'image':[]})
    driver.get(main_link)
    # more_button = driver.find_element(By.CLASS_NAME,'section_more_inner._CONTENT_LIST_LOAD_MORE_BUTTON')
    # 요소가 나타날 때까지 기다립니다.
    more_button = WebDriverWait(driver, 2).until(
        EC.presence_of_element_located((By.CLASS_NAME, 'section_more_inner._CONTENT_LIST_LOAD_MORE_BUTTON'))
    )
    itter = 0
    while itter < 10 : 
        try :
            itter+=1 
            more_button.click()
            time.sleep(np.random.rand()+0.83)
        except :
            continue
        
    articles = driver.find_elements(By.CLASS_NAME, 'sa_text_title')
    #print(articles)
    print(f"현재날짜 뉴스{date}")
    
    # img = driver.find_element(By.CSS_SELECTOR,'a.dsc_thumb ').find_element(By.CSS_SELECTOR, 'img')
    # img = img.get_attribute('src')
    # print("image: ",img)
    # import matplotlib.pyplot as plt
    # plt.imshow(img)
    # plt.show()
    
    for i in range(len(articles)):
        if i <10: ## 기사는 100개이하로 가져온다. 
            title = articles[i].text.strip()
            print(f" |- {i+1}.",title)
            link = articles[i].get_attribute('href')

            ### -------- 기사 본문
            headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"}
            try : 
                time.sleep(np.random.rand()+0.13)
                response  = requests.get(link,headers =headers)
                if response.status_code ==200:
                    html = response.content
                    soup = BeautifulSoup(html,'html.parser')
                    info = soup.find('div',{'id': 'newsct_article'}).text.strip() # 뉴스 기사 
                    info = info.replace("\n","")
                    print("  * info : ",info)
                    if info : 
                        article_content= info
                    else :
                        article_content = ""
                    
                    ### image source 
                    chrome_options = webdriver.ChromeOptions()
                    driver = webdriver.Chrome(service = Service(ChromeDriverManager().install()), options = chrome_options)
                    driver.get(link)
                    print(f"신문 기사 링크 : {link}")
                    # 이미지 태그 찾기 (id 사용)
                    image_element = driver.find_element(By.ID, "img1")
                   
                    if image_element.get_attribute("src"):
                        image_src = image_element.get_attribute("src")
                    else:
                        iamge_src = ""
                    print(f"image source link: ",image_src)
                    li = [i+1, title, link, article_content, image_src]
                    Main_link.loc[i] = li # 행 추가 
            except: 
                print("article 없음")
                article_content=""
                iamge_src = ""
                
            
        if Main_link.empty:
            print("비어있습니다. 크롤링 실패 ")
        else:
            Main_link.to_csv(f"Date_{date}Sid_{Sid}.csv",index=None)
    return Main_link


if __name__ == '__main__':
    # 프로세스를 생성
    p0 = Process(target=naver_newsCrawling, args=101) 
    # p1 = Process(target=naver_newsCrawling(Sid=101)) 
    # p2 = Process(target=naver_newsCrawling(Sid=102)) 
    # p3 = Process(target=naver_newsCrawling(Sid=103)) 
    # p4 = Process(target=naver_newsCrawling(Sid=104)) 
    # p5 = Process(target=naver_newsCrawling(Sid=105)) 
    # p6 = Process(target=naver_newsCrawling(Sid=106)) 
    # Process 시작
    p0.start()
    # p1.start()
    # p2.start()
    # p3.start()
    # p4.start()
    # p5.start()
    # p6.start()

    # 종료 대기
    p0.join()
    # p1.join()
    # p2.join()
    # p3.join()
    # p4.join()
    # p5.join()
    # p6.join()

    print("<<<<< End >>>>>")