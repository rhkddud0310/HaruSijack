
"""
 ## Desc : chat bot service api 
## Author : harusizakc
## update: 
    * 2024.06.28 by pdg : service update
        - nlp service update
        - news service update 
"""

from fastapi import APIRouter
router = APIRouter()
@router.get("/chatbot")
async def read_item( query_parameter: str = None):
    return {"message":" harusizack chat bot service!"}




# uvicorn fastapi_02:app --reload

from common import get_client, get_model
from Functions import NLP_Service as N
from pprint import pprint
from Functions import Service as S
def blue(str):return S.colored_text(str,'blue')
def yellow(str):return S.colored_text(str,'yellow')
def red(str):return S.colored_text(str,'red')
def green(str):return S.colored_text(str,'green')
def imd(str):return S.imd(green(str))
## 자연어처리 패키지 설치 

class Chatbot:
    
    def __init__(self, model):
        self.context = [{"role": "system", "content": "You are a helpful assistant."}]
        self.model  = get_model()
        self.client = get_client()  # client를 인스턴스 변수로 저장
        self.r_a_dict = ""


    def add_user_message(self,message):
        self.context=[{"role":"system", "content":'You are a helpful assistant.'}]
        self.context.append({"role":"user", "content":message})
    def add_ML_result(self, r_a_dict):
        self.r_a_dict=[{"role":"system", "content":'You are a helpful assistant.'}]
        self.r_a_dict.append(r_a_dict)
        
        
    def determin_question_is_about_subway(self):
        print(yellow("사용자가 말한 메세지 : "),self.context)
        import time, datetime
        today = datetime.date.today()
        date = today.strftime("%Y-%m-%d")
        template = """
            당신은 번역함수이며, 반환값은 반드시 JSON 데이터 여야 합니다. 
            
            STEP 별로 작업을 수행하면서 그 결과를 아래의 출력 결과 JSON 포맷에 작성하세요.
            STEP-1. 입력받은 텍스트 안에 서울 지하철 이름이 있으면 지하철역 이름 을 표기할것 
            STEP-2. 입력받은 텍스트 안에 서울 지하철의 호선 정보가 았으면 몇호선인지 숫자를 str으로 표기할것
            STEP-3. 입력받은 텍스트 안에날짜로 추정되는 정보가 있으면  날짜를 yyyy-mm-dd 양식으로 표기할것 . 
            오늘이라는 표현이 있으면 {today}를  yyyy-mm-dd 양식으로 표기할것
            
            ```{text}```
            ```{today}```
            
            ---
            출력결과 : {{"stationName":<지하철역 이름>, "stationLine": <"숫자"> ,"date": <4자리수년도-두자리수월-두자리수일>}}
            """
            
        template = template.format(text=self.context, today=date)
        messages = [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": template}  # template 문자열을 JSON 객체로 변환
        ]
        response = self.client.chat.completions.create(
            model =self.model.basic,
            messages = messages,
            response_format ={"type":"json_object"}
        ).model_dump()
        print(yellow("start"))
        print(yellow(response['choices'][0]['message']['content']))
        json_result =response['choices'][0]['message']['content']
        return json_result
        
    def response_GPT_from_inputMLResult(self):
        print(yellow("사용자가 보낸 승하차 정보 : "),self.context)
        import time, datetime
        now = datetime.datetime.now()  # 현재 시각
        hour = now.hour  # 시간대 추출 (0~23)
        print(hour)  # 예를 들어 현재 시간이 오후 3시 15분이면 15가 출력됩니다.
        template = """
            반환값은 반드시 str 타입이어야합니다.
            
            STEP 별로 작업을 수행하여 출력결과를 작성하세요.
            STEP-1. 받은 값에서 승하차 정보를 구분하여 {now}시간대에서ㅕ의 승하차 인원이 각각 몇 명인지 구분할것.
            STEP-2. 
            STEP-3. 
            ```{text}```
            ```{now}```
            
            ---
            출력결과 : " 예상 승차인원은 <승차인원> 하차인원은  <승차인원>  입니다. "
            """
            
        template = template.format(text=self.context, now=str(hour))
        messages = [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": template}  # template 문자열을 JSON 객체로 변환
        ]
        response = self.client.chat.completions.create(
            model =self.model.basic,
            messages = messages,
            response_format ={"type":"json_object"}
        ).model_dump()
        print(yellow("start"))
        print(yellow(response['choices'][0]['message']['content']))
        json_result =response['choices'][0]['message']['content']
        return json_result
        
        
        
    def send_request(self):
        response = self.client.chat.completions.create(
            model =self.model.basic,
            messages = self.context
        ).model_dump()
        return response
    def add_response(self,response):
        self.context.append({
            "role": response['choices'][0]['message']["role"],
            "content" : response['choices'][0]['message']["content"]
        })
    def get_response_content(self):
        return self.context[-1]['content']
    

if __name__ =="__main__":
    # step -3 : 테스트 시나리오에 따라 실횅코드 작성 및 예상 출력 결과 작성
    model = get_model()
    client = get_client()
    chatbot = Chatbot(model.basic)
    print(yellow(model.basic),red("Chat bot service 시작"))
    
    chatbot.add_user_message("서울 지하철 5호선 은 뭐가 있어?")
    
    ## 시나리오 1-4 : 현재 context 를 openai api 입력값으로 설정하여 전송
    response = chatbot.send_request()
    print(yellow("함수실행 "))
    ml_input_from_chat = chatbot.determin_question_is_about_subway()
    # rrr = chatbot.determin_question_is_about_subway()
    
    # 시나리오 1-5 : 응답 메세지를 context 에 추가 
    chatbot.add_response(response)

    # 시나리오 1-7 : 응답 메세지 출력 
    print(red("하루 : "),blue(chatbot.get_response_content()))
    
    # 시나리오 2-2  사용자가 채팅창에 오늘날씨 어때 입력
    chatbot.add_user_message("그중에 제일 혼잡한 역은어디야?")
    
    # 다시 요청 보내기 
    # response = chatbot.send_request()
    
    # 응답 메세지를 context 에 추가 
    # chatbot.add_response(response)
    
    print(red("하루 : "),blue(chatbot.get_response_content()))
