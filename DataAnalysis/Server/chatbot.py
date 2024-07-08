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


    def add_user_message(self,message):
        self.context.append({"role":"user", "content":message})
        
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
    
    # 시나리오 1-5 : 응답 메세지를 context 에 추가 
    chatbot.add_response(response)

    # 시나리오 1-7 : 응답 메세지 출력 
    print(red("하루 : "),blue(chatbot.get_response_content()))
    
    # 시나리오 2-2  사용자가 채팅창에 오늘날씨 어때 입력
    chatbot.add_user_message("그중에 제일 혼잡한 역은어디야?")
    
    # 다시 요청 보내기 
    response = chatbot.send_request()
    
    # 응답 메세지를 context 에 추가 
    chatbot.add_response(response)
    
    print(red("하루 : "),blue(chatbot.get_response_content()))
