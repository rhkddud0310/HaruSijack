//
//  PredictView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/1/24.
//  Description : 지하철 혼잡도 예측 페이지
//  UpDate : 2024-06-10
//          1. 역별 버튼 생성
//          2. 역 버튼 클릭시 현재날짜, 시각, 역이름 flask서버로 보내고 result값 받아오는 함수 생성

import SwiftUI
import Zoomable

// 시간 되면 오늘 ZoomableScrollView도 추가해서 모든방향 스크롤 하기

struct PredictView: View {
    
    @State private var dragAmount = CGSize.zero
    @State var stationName: String = ""
    @State var stationLine: String = "7"
    var bgColor: Color = Color.red
    @FocusState var isTextFieldFocused: Bool
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        
        
        VStack {
            
        

           ZStack(content: {
               
               //스크롤뷰 [노선도 사진]
               ScrollView([.horizontal, .vertical], showsIndicators: false , content: { //showsIndicators : 스크롤바 안보이게
//                   ScrollView(.horizontal, showsIndicators: false ,content: {
                      Image("Line7")
                           .resizable()
                           .frame(width: 1000, height: 1700)
                           .zoomable() // double click시 화면 확대
                           .overlay(
                                    Button(action: {
                                        stationName = "장암"
                                        
//                                        print("장암")
                                        let (dateString, timeString) = getCurrentDateTime()
                                        print(dateString,timeString, stationName, stationLine)
                                        fetchDataFromServer(stationName: stationName, date: dateString, time: timeString, stationLine:stationLine)
                                    }, label: {
                                        Text("T")
                                            .frame(width: 20, height: 20)
                                            .background(bgColor)
                                            .clipShape(Circle())
                                    })
                                    .position(x: 155, y: 345) // 여기서 버튼 위치 조정
                                    
                                              )
                           .overlay(
                                    Button(action: {
                                        stationName = "도봉산"
                                        let currentDateTime = getCurrentDateTime()
                                        print(currentDateTime, stationName)
                                        
                                    }, label: {
                                        Text("T")
                                            .frame(width: 20, height: 20)
                                            .background(bgColor)
                                            .clipShape(Circle())
                                    })
                                    .position(x: 255, y: 345) // 여기서 버튼 위치 조정
                                    
                                              )
                   })
                   .frame(maxWidth: .infinity)
                   .gesture(
                       DragGesture()
                           .onChanged { value in
                               self.dragAmount = value.translation
                           }
                           .onEnded { _ in
                               self.dragAmount = .zero
                           }
                   )
                   .offset(x: dragAmount.width, y: dragAmount.height)
//               })//ScrollView

           })// Zstack
        } //Vstack
    } //body
}

                            
#Preview {
    PredictView()
}



// 현재시간 가져오는 함수
func getCurrentDateTime() -> (String,String) {
    let currentDate = Date()

    // Date Formatter for Date
    let dateFormatterDate = DateFormatter()
    dateFormatterDate.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatterDate.string(from: currentDate)

    // Date Formatter for Time
    let dateFormatterTime = DateFormatter()
    dateFormatterTime.dateFormat = "HH"
    let timeString = dateFormatterTime.string(from: currentDate)

    return (dateString, timeString)
}


// flask 통신을 위한 함수
func fetchDataFromServer(stationName: String, date: String ,time: String, stationLine : String) {
    let url = URL(string: "http://localhost:5000/subway")!
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    // request한 값을 json이라고 명시해줌(안하면 json형식이여도 json이 아니라고 오류남)
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
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)
        }
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response:", responseString)
        }
    }
    
    // URLSession Task 시작
    task.resume()
}

//button function으로 만들기 (진행중) -> wrapped 붙이고 처리해야할 변수들이 너무 많아서 보류..
//func stationButton(stationName: Binding<String>) -> some View {
//    Button(action: {
//        stationName.wrappedValue = "장암"
//        let (dateString, timeString) = getCurrentDateTime()
//        print(dateString, timeString, stationName.wrappedValue, stationLine.wrappedValue)
//        fetchDataFromServer(stationName: stationName.wrappedValue, date: dateString, time: timeString, stationLine: stationLine)
//    }, label: {
//        Text("T")
//            .frame(width: 20, height: 20)
//            .background(bgColor)
//            .clipShape(Circle())
//    })
//    .position(x: 155, y: 345) // 버튼 위치 조정
//}

