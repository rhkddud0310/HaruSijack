//// MARK: -- Description
///*
//Description:  version 04 는 내가 지환씨 코드를 이해하려고 이것저것 건드리는 테스트 코드임.
//Date : 2024.6.29
//Author : pdg
//Dtail :
//Updates :
//    - 2024.06.29 by pdg :
//        * abuttom 색 지움
// * 종로 5가역 은 없음
// * zoom 하고 scroll 이 이상함.
// * 이미지가 갑자기 사라져 버림. 
// */
//
//import SwiftUI
//struct PredictView04: View {
//    var body: some View {
//        VStack(content: {
//            ZStack(content: {
//                GeometryReader { geometry in
//                    subwayImage01()
//                }// GR
//            })//ZS
//        })//VS
//    }
//}
//
//
//struct subwayImage01 : View {
//
//    // MARK: --- Server request 변수
//    @State var stationName: String = ""
//    @State var stationLine: String = "5"
//    @State private var showAlertForStation = false
//    @State var serverResponseBoardingPerson: String = ""
//    @State var serverResponseAlightingPerson: String = ""
//    @State var boardingPersonValue: Double = 0.0
//    @State var AlightingPersonValue: Double = 0.0
//    @State var showingcurrentdate = ""
//    @State var showingcurrentTime = ""
//    @State private var BoardingPersondictionary: [String: Double] = [:]
//    @State private var AlightinggPersondictionary: [String: Double] = [:]
//    @State private var isLoading = false
//    
//    // MARK: ---- 화면조작 변수
//    // 초기화면 위치 지정
//    @State var currentScale: CGFloat = 0.5
//    @State var previousScale: CGFloat = 1.0
//    @State var currentOffset = CGSize(width: -1500, height: -800)
//    @State var previousOffset = CGSize.zero
//    let line23 = SubwayList().totalStation
////    let line23 = SubwayList().testStation
//    let imgWidth = UIImage(named: "subwayMap")!.size.width
//    let imgHeight = UIImage(named: "subwayMap")!.size.height
//    
//    
//    
//    // MARK: Image Body
//    var body: some View {
//        Image("subwayMap")
//            .resizable()
//            // MARK: Image size
//            .frame(
//                width: imgWidth * self.currentScale,
//                height: imgHeight * self.currentScale)
//        
//            .overlay( GeometryReader { geometry in
//                ForEach(Array(line23.enumerated()), id: \.0) { index, station in
//                    // MARK: Image Buttom
//                    Button(action: {
//                        isLoading = true
//                        print("변수값 확인-----------------------")
//                        print("line5 station \(station.0)")
//                        print("line5 station \(station.3)")
//                        print("line5 station \(station.4)")
//                        print("line5 station \(station.5)")
//                        print("변수값 확인-----------------------")
//                        handleStationClick(stationName: station.0, stationLine: String(station.3))
//                    }) {
//                        Text("\(station.0)")
//                            .font(.system(size: 10))
//                            .bold()
//                            .frame(width: 60, height: 20)
////                            .background(Color.yellow)
//                    }
//                    .position(  x: (station.2 * self.currentScale),
//                                y: (station.1 * self.currentScale))
//                }//button
//            })// OverLay
//            .edgesIgnoringSafeArea(.all)
//            .aspectRatio(contentMode: .fit)
//            .offset(x: self.currentOffset.width, y: self.currentOffset.height)
//            .scaleEffect(max(self.currentScale, 1.0)) // the second question
//            .gesture(DragGesture()
//                .onChanged { value in
//                    
//                    let deltaX = value.translation.width - self.previousOffset.width
//                    let deltaY = value.translation.height - self.previousOffset.height
//                    self.previousOffset.width = value.translation.width
//                    self.previousOffset.height = value.translation.height
//                    
//                    //                            let newOffsetWidth = self.currentOffset.width + deltaX / self.currentScale
//                    
//                    self.currentOffset.width = self.currentOffset.width + deltaX / self.currentScale
//                    self.currentOffset.height = self.currentOffset.height + deltaY / self.currentScale
//                }
//                     
//                .onEnded { value in self.previousOffset = CGSize.zero })
//        
//        
//            .gesture(MagnificationGesture()
//                .onChanged { value in
//                    let delta = value / self.previousScale
//                    print(delta)
//                    self.previousScale = value
//                    self.currentScale = self.currentScale * delta
//                }
//                .onEnded { value in self.previousScale = 1.0 }
//                
//            )
//            .sheet(isPresented: $showAlertForStation, onDismiss: {
//                // 변수 초기화
//                isLoading = false
//                stationName = ""
//                boardingPersonValue = 0
//                AlightingPersonValue = 0
//                BoardingPersondictionary = [:]
//                AlightinggPersondictionary = [:]
//             })  {
//                SheetContentView(
//                    isLoading: $isLoading,
//                    stationName: $stationName,
//                    showingcurrentTime: $showingcurrentTime,
//                    boardingPersonValue: $boardingPersonValue,
//                    AlightingPersonValue: $AlightingPersonValue,
//                    BoardingPersondictionary: $BoardingPersondictionary,
//                    AlightinggPersondictionary: $AlightinggPersondictionary
//                )
//        }//sheet
//    }// View
//    
//    // MARK: Functions
//    func handleStationClick(stationName: String, stationLine: String) {
//        self.stationName = stationName
//        self.stationLine = stationLine
//        let (dateString, timeString) = getCurrentDateTime()
//        showingcurrentTime =  timeString
//        showingcurrentdate =  dateString
//        //승차인원
//        fetchDataFromServerBoarding(stationName: stationName, date: dateString, time: timeString, stationLine: stationLine) { responseString in
//            self.serverResponseBoardingPerson = responseString
//            self.boardingPersonValue = getValueForCurrentTime(jsonString: responseString, currentTime: timeString)
//            // 받아온 JSON데이터를 dictionary로 변경
//            if let dictionary = convertJSONStringToDictionary(responseString) {
//                //현재시간에서 범위에 있는 값들을 임시저장하기위한 딕셔너리
//                var tempBoardingPersondictionary: [String: Double] = [:]
//                // 정렬해서 배열로 가져오기(index번호로 데이터 가져오기 위해서)
//                let sortedKeys = dictionary.keys.sorted()
//                //lowerBound: 현재시시간에서 -7값이 0보다 작으면 0으로 고정(-7한 이유:배차시작이5기 때문)
//                //upperBound: 키값에 인덱스를 초과한 값 방지
//                let lowerBound = max(0, Int(showingcurrentTime)! - 7)
//                let upperBound = min(sortedKeys.count - 1, Int(showingcurrentTime)! - 3)
//                if lowerBound <= upperBound && sortedKeys.indices.contains(upperBound) {
//                    for index in lowerBound...upperBound {
//                        let key = sortedKeys[index]
//                        if let value = dictionary[key] {
//                            tempBoardingPersondictionary[key] = value
//                        }
//                    }
//                }
//                //전역변수에 저장
//                self.BoardingPersondictionary = tempBoardingPersondictionary
//            } else {
//                print("인덱스 범위 오류")
//            }
//            showAlertForStation = true
//        } // fetchDataFromServerBoarding
//        //하차인원
//        fetchDataFromServerAlighting(stationName: stationName, date: dateString, time: timeString, stationLine: stationLine) { responseString in
//            self.serverResponseAlightingPerson = responseString
//            self.AlightingPersonValue = getValueForCurrentTime(jsonString: responseString, currentTime: timeString)
//            //            let alightingTime=showingcurrentTime
//            if let dictionary = convertJSONStringToDictionary(responseString) {
//                //현재시간에서 범위에 있는 값들을 임시저장하기위한 딕셔너리
//                var tempAlightingPersondictionary: [String: Double] = [:]
//                // 정렬해서 배열로 가져오기(index번호로 데이터 가져오기 위해서)
//                let sortedKeys = dictionary.keys.sorted()
//                
//                //lowerBound: 현재시시간에서 -7값이 0보다 작으면 0으로 고정(-7한 이유:배차시작이5기 때문)
//                //upperBound: 키값에 인덱스를 초과한 값 방지
//                let lowerBound = max(0, Int(showingcurrentTime)! - 7)
//                let upperBound = min(sortedKeys.count - 1, Int(showingcurrentTime)! - 3)
//                if lowerBound <= upperBound && sortedKeys.indices.contains(upperBound) {
//                    for index in lowerBound...upperBound {
//                        let key = sortedKeys[index]
//                        if let value = dictionary[key] {
//                            tempAlightingPersondictionary[key] = value
//                        }
//                    }
//                }
//                //전역변수에 저장
//                self.AlightinggPersondictionary = tempAlightingPersondictionary
//            } else {
//                print("인덱스 범위에 해당하는 요소가 없습니다.")
//            }
//            showAlertForStation = true
//        } //fetchDataFromServerAlighting
//    } //handleStationClick
//    // 현재시간 가져오는 함수
//    func getCurrentDateTime() -> (String, String) {
//        let currentDate = Date()
//        // Date Formatter for Date
//        let dateFormatterDate = DateFormatter()
//        dateFormatterDate.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatterDate.string(from: currentDate)
//        // Date Formatter for Time
//        let dateFormatterTime = DateFormatter()
//        dateFormatterTime.dateFormat = "HH"
//        let timeString = String(Int(dateFormatterTime.string(from: currentDate))!)
//        return (dateString, timeString)
//    }
//    // Flask 통신을 위한 함수(승차인원)
//    func fetchDataFromServerBoarding(stationName: String, date: String, time: String, stationLine: String, completion: @escaping (String) -> Void) {
//        let url = URL(string: "http://54.180.247.41:5000/subway")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let parameters: [String: Any] = [
//            "stationName": stationName,
//            "date": date,
//            "time": time,
//            "stationLine": stationLine
//        ]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error:", error ?? "Unknown error")
//                return
//            }
//            if let responseString = String(data: data, encoding: .utf8) {
//                completion(responseString)
//            }
//        }
//        task.resume()
//    }
//
//    // Flask 통신을 위한 함수(하차인원)
//    func fetchDataFromServerAlighting(stationName: String, date: String, time: String, stationLine: String, completion: @escaping (String) -> Void) {
//        print(stationName,date,time,stationLine)
//        let url = URL(string: "http://54.180.247.41:5000/subwayAlighting")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let parameters: [String: Any] = [
//            "stationName": stationName,
//            "date": date,
//            "time": time,
//            "stationLine": stationLine
//        ]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error:", error ?? "Unknown error")
//                
//                return
//            }
//            if let responseString = String(data: data, encoding: .utf8) {
//                completion(responseString)
//            }
//        }
//        task.resume()
//    }
//
//    // 현재시간에 "시인원"을 더한 값을 key값으로 서버에서 받아온 JSON값에서 검색해서 값을 가져오는 함수
//    func getValueForCurrentTime(jsonString: String, currentTime: String) -> Double {
//        guard let jsonData = jsonString.data(using: .utf8) else { return 0.0 }
//        do {
//            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//                let keyForCurrentTime = "\(currentTime)시인원"
//                if let value = json[keyForCurrentTime] as? Double {
//                    return value
//                }
//            }
//        } catch {
//            print("Error parsing JSON:", error)
//        }
//        return 0.0
//    }
//
//    // JSON 데이터를 dictionary로 변환(차트그리기 위해서)
//    func convertJSONStringToDictionary(_ jsonString: String) -> [String: Double]? {
//        guard let jsonData = jsonString.data(using: .utf8) else {
//            print("딕셔너리 변환 실패.")
//            return nil
//        }
//        
//        do {
//            let dictionary = try JSONDecoder().decode([String: Double].self, from: jsonData)
//            return dictionary
//        } catch {
//            print("Error decoding JSON: \(error.localizedDescription)")
//            return nil
//        }
//    }
//}
//// MARK: Preview
//#Preview {
//    PredictView04()
//}
