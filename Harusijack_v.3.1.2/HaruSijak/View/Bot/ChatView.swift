//
//오늘 군자역 5호선 혼잡도 알려줘
//  ChatView.swift
//  HaruSijak
//
//  Created by 신나라 on 7/2/24.

/* 2024.07.03 snr : 챗봇 화면 구성
        - ScrollView로 되게 구현해야됨
        - 텍스트 입력부분 Zstack으로 감싸기
   2024
*/

import SwiftUI
struct ChatView: View {
    @State var showWelcomMessage = false
    @State var isAnimation = false
    @State var humanInput: String = ""
    @State var chatLogs: [String] = ["C:안녕하세요. 하루입니다. 무엇을 도와드릴까요?"]
    @FocusState var isTextFieldFocused: Bool
    @State var step1 = ""
    @State var step2 = ""
    @State var step3 = ""
    @State var r_a_predicted: [String:String] = ["승차": "", "하차":""]
    // 챗봇 대답
    @State private var responseMessage: String = ""
    
    var body: some View {
        
        // ****** 이부분 ScrollView로 되게 수정해야됨
        VStack(content: {
            if showWelcomMessage {
                
                
                // 대화 기록 표시
                ScrollView(content: {
                    ForEach(chatLogs, id: \.self) { log in
                        if log.starts(with: "H:") {
                            if let humanTalk = log.split(separator: ":").last.map(String.init)?.trimmingCharacters(in: .whitespaces) {
                                showHumanTalk(humanTalk)
                                Text(humanTalk)
                            }
                        } else {
//                            chatbot response log
                            if let chatBotTalk = log.split(separator: "@#@!!").last.map(String.init)?.trimmingCharacters(in: .whitespaces)
                            {
                                showChatBotTalk(chatBotTalk)
                            }
                        }//else
                    }// for each
                })
              
            }// if
            Spacer()
            //****** 이부분 Zstack으로 수정해야되고
            HStack(content: {
                TextField("텍스트를 입력하세요.", text: $humanInput)
                    .frame(width: UIScreen.main
                        .bounds.width * 0.80)
                    .cornerRadius(8)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    print("\(humanInput)")
                    sendUserInput()
                }, label: {
                    Image(systemName: "arrow.up.square.fill")
                        .font(.largeTitle)
                })
            })
            .padding(.horizontal, 20)
        })
        
        .padding(.top, 40)
        .navigationTitle("하루챗봇")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5 ) {
                withAnimation(.easeIn(duration: 1)) {
                    isAnimation.toggle()
                    showWelcomMessage = true
                }
            }
        }
    }
    
    
    // -------------------- functions ----------------------
    // 사용자 입력 전송 및 처리
    func sendUserInput() {
        //사용자 입력 기록 추가
        chatLogs.append("H:" + humanInput)
        fetchResponse(message: humanInput) { result in
            switch result {
            case .success(let response):
                print("서버 통신 성공 :\(response)")
                
                let jsonconvert = jsonConverter()
                guard case let (name?, line?, date?) = jsonconvert.StringToJson(jsonData: response) else {
                    print("JSON 데이터에서 값을 가져오지 못했습니다.")
                    return // 오류 발생 시 함수 종료
                }
                fetchDataFromServerBoarding(stationName: "\(String(name.dropLast()))", date: "\(date)", time: "", stationLine: "\(line)", completion: { responseString in
                    print()
                })
                fetchDataFromServerAlighting(stationName: "\(String(name.dropLast()))", date: "\(date)", time: "", stationLine: "\(line)", completion: { responseString in
                    print()
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//                    print("r_a_predicted: \(r_a_predicted)")
                    // Server 통신 코드
                    print(" 📌 - machinelearning 결과를 서버에 보냅니다.")
                    MLResponse(message: "\(r_a_predicted)", completion: { res in
                        print(" server 와 통신완료")
                        
                    })
                    
                    
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    return
                }
            }
        }
//        print("response : \(responseMessage)")
//        print("Haru : ", chatLogs[1])
        
        // 챗봇이 응답하도록 로직 구현
        humanInput = ""
    }
    
    // 사용자가 입력한 단어 분석 -> return값은 String으로 일단
    func generateChatBotResponse(_ quest: String) -> String {
        
        if quest.contains("지하철 혼잡도") || quest.contains("혼잡도") {
            // [지하철 혼잡도], [혼잡도]라는 단어가 포함되어 있을 때 로직 => 사용자 입력텍스트에서 유사도를 체크해야되겠??
        } else if (quest.contains("일정") || quest.contains("스케줄") || quest.contains("스케쥴")) {
            // [일정], [스케쥴], [스케줄]라는 단어가 포함되어 있을 때 로직 => 사용자 입력텍스트에서 유사도를 체크해야되겠??
        }
        return ""
    }
    // MARK: Fetch Response from Server
    func fetchResponse(message: String, completion: @escaping (Result<String, Error>) -> Void) {
            let server_ip="http://54.180.247.41:5000/chat-api"
//            let local_ip="http://127.0.0.1:5000/chat-api"
            guard let url = URL(string: server_ip ) else {
                
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            print("server request: \(url)")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestBody: [String: Any] = ["request_message": message]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            } catch {
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(NSError(domain: "HTTP error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let responseMessage = json["response_message"] as? String {
                        completion(.success(responseMessage))
                        print("test : ")
                        print("-----------------------------------")
                        print(completion(.success(responseMessage)))
                        print("-----------------------------------")
                        return completion(.success(responseMessage))
                    } else {
                        completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    
    
    func MLResponse(message: String, completion: @escaping (Result<String, Error>) -> Void) {
            let server_ip="http://54.180.247.41:5000/chat-api"
//            let local_ip="http://127.0.0.1:5000/chat-api"
            guard let url = URL(string: server_ip ) else {
                
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            print("server request: \(url)")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestBody: [String: Any] = ["request_message": message]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            } catch {
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(NSError(domain: "HTTP error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let responseMessage = json["response_message"] as? String {
                        completion(.success(responseMessage))
                        print("test : ")
                        print("-----------------------------------")
                        print(completion(.success(responseMessage)))
                        print("-----------------------------------")
                        return completion(.success(responseMessage))
                    } else {
                        completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    
    /* MARK: chatbot Image Circle & Talk */
    func showChatBotTalk(_ talk: String) -> some View {
        
        VStack(content: {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    Image("chatImage")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                Spacer()
            }
            //오늘 군자역 5호선 혼잡도 알려줘
            
            HStack {
                Text("")
                    .onAppear{
                        print("talk test :\(talk)")
                        
                    }
                Text(talk)

                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.scale)
                    .fixedSize(horizontal: false, vertical: false)
                    .alignmentGuide(.leading) { _ in 0}
                Spacer()
            }
//             Spacer()
        }) //Vstack
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    } //showChatImage
    
    /* MARK: Human Image Circle & Talk */
    func showHumanTalk(_ talk: String) -> some View {
        VStack(content: {
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("myColor"))
                    
                    Image("human")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            
            HStack {
                Spacer()
                Text(talk)
                    .padding()
                    .background(Color("myColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.scale)
                .alignmentGuide(.leading) { _ in 0}
                
            }
//             Spacer()
        }) //Vstack
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
    } //showChatImage
    
    /* MARK: 승차인워원 예측을 위한 서버통신 */
    func fetchDataFromServerBoarding(stationName: String, date: String, time: String, stationLine: String, completion: @escaping (String) -> Void) {
        // 127.0.0.1
        //개인 faskapi
        let url = URL(string: "http://54.180.247.41:8000/subway/subwayRide")!
        // 개인 flask
        //        let url = URL(string: "http://127.0.0.1:5000/subwayRide")!
        // aws flask
        //        let url = URL(string: "http://54.180.247.41:5000/subwayRide")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "stationName": stationName,
            "date": date,
            "time": time,
            "stationLine": stationLine
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error:", error ?? "Unknown error")
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
                self.r_a_predicted["승차"] = responseString
                print("📌 ---- ra 승차 인원 append 됨")
            }
        }
        task.resume()
        completion("")
    }
    
    /* MARK: 하차인워원 예측을 위한 서버통신 */
    func fetchDataFromServerAlighting(stationName: String, date: String, time: String, stationLine: String, completion: @escaping (String) -> Void) {
        print(stationName,date,time,stationLine)
        //127.0.0.1 54.180.247.41:
        //개인 fasdtapi
        let url = URL(string: "http://54.180.247.41:8000/subway/subwayAlighting")!
        //개인 flask
        //        let url = URL(string: "http://127.0.0.1:5000/subwayAlighting")!
        //aws flask
        //        let url = URL(string: "http://54.180.247.41:5000/subwayAlighting")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "stationName": stationName,
            "date": date,
            "time": time,
            "stationLine": stationLine
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error:", error ?? "Unknown error")
                
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
                self.r_a_predicted["하차"] = responseString
                print("📌 ---- ra 하차 인원 append 됨")
            }
            
        }
        task.resume()
        completion("")
    }
    
}

#Preview {
    ChatView()
}
