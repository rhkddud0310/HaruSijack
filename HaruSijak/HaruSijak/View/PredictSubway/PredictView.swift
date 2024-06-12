import SwiftUI
import Zoomable

struct PredictView: View {
    
    @State private var dragAmount = CGSize.zero
    @State var stationName: String = ""
    @State var stationLine: String = "7"
    var bgColor: Color = Color.red
    @FocusState var isTextFieldFocused: Bool
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    //----  server  ----
    @State private var showAlertForStation = false
    // 승차인원 JSON 받아오는 변수(승차)
    @State var serverResponseBoardingPerson: String = ""
    // 승차인원 JSON 받아오는 변수(하차)
    @State var serverResponseAlightingPerson: String = ""
    // 현재시간 열차의 승차인원 변수
    @State var boardingPersonValue: Double = 0.0
    // 현재시간 열차의 하차인원 변수
    @State var AlightingPersonValue: Double = 0.0
    
    
    //문제 역 -> 노원, 태릉입구, 군자,건대입구, 고속터미널,대림
    // 서버에서 확인해본 결과 노원에 대한 데이터를 찾을 수 없음 -> 데이터셋에는 있는데 역사 코드가 중첩된게 문제인걸까?
    // 역과 위치 정보
    let stations = [
        ("장암", 80.0, 163.0),
        ("도봉산", 135.0, 164.0),
        ("수락산", 189.0, 161.0),
        ("마들", 245.0, 164.0),
        ("노원", 298.0, 162.0),
        ("중계", 351.0, 161.0),
        ("하계", 407.0, 162.0),
        ("공릉", 462.0, 161.0),
        ("태릉입구", 513.0, 158.0),
        ("먹골", 567.0, 162.0),
        ("중화", 623.0, 162.0),
        ("상봉", 674.0, 161.0),
        ("면목", 730.0, 161.0),
        ("사가정", 710.0, 300.0),
        ("용마산", 645.0, 301.0),
        ("중곡", 581.0, 300.0),
        ("군자", 514.0, 299.0),
        ("어린이대공원", 451.0, 298.0),
        ("건대입구", 385.0, 299.0),
        ("뚝섬유원지", 319.0, 300.0),
        ("청담", 257.0, 300.0),
        ("강남구청", 187.0, 300.0),
        ("학동", 124.0, 300.0),
        ("논현", 61.0, 298.0),
        ("반포", 63.0, 450.0),
        ("고속터미널", 129.0, 452.0),
        ("내방", 194.0, 454.0),
        ("이수", 257.0, 452.0),
        ("남성", 324.0, 451.0),
        ("숭실대입구", 387.0, 454.0),
        ("상도", 453.0, 453.0),
        ("장승배기", 519.0, 452.0),
        ("신대방삼거리", 585.0, 452.0),
        ("보라매", 648.0, 450.0),
        ("신풍", 714.0, 453.0),
        ("대림", 712.0, 614.0),
        ("남구로", 648.0, 612.0),
        ("가산디지털단지", 580.0, 613.0),
        ("철산", 518.0, 613.0),
        ("광명사거리", 451.0, 611.0),
        ("천왕", 388.0, 611.0),
        ("온수", 322.0, 612.0),
        
    ]
    
    
    var body: some View {
        VStack {
            ZStack {
                // 스크롤뷰 [노선도 사진]
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Image("Line7")
                        .resizable()
                        .frame(width: 800, height: 800)
                        .zoomable() // double click시 화면 확대
                        .overlay(
                            ForEach(stations, id: \.0) { station in
                                Button(action: {
                                    handleStationClick(stationName: station.0)
                                }) {
                                    Text("")
                                        .frame(width: 20, height: 20)
                                        .background(Color.clear)
                                }
                                .position(x: station.1, y: station.2)
                                .actionSheet(isPresented: $showAlertForStation) {
                                    ActionSheet(
                                        title: Text(stationName),
                                        message: Text("현재 시간의 탑승인원: \(Int(boardingPersonValue))\n현재 시간의 하차인원:\(Int(AlightingPersonValue))"),
                                        buttons: [
                                            .default(Text("OK"))
                                        ]
                                    )
                                }
                            }
                        )
                }
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
            }
        }
    }
    
    // 역 클릭 처리 함수
    func handleStationClick(stationName: String) {
        self.stationName = stationName
        let (dateString, timeString) = getCurrentDateTime()
        //승차인원
        fetchDataFromServerBoarding(stationName: stationName, date: dateString, time: timeString, stationLine: stationLine) { responseString in
            self.serverResponseBoardingPerson = responseString
            self.boardingPersonValue = getValueForCurrentTime(jsonString: responseString, currentTime: timeString)
            showAlertForStation = true
        }
        //하차인원
        fetchDataFromServerAlighting(stationName: stationName, date: dateString, time: timeString, stationLine: stationLine) { responseString in
            self.serverResponseAlightingPerson = responseString
            self.AlightingPersonValue = getValueForCurrentTime(jsonString: responseString, currentTime: timeString)
            showAlertForStation = true
        }
    }
}

#Preview {
    PredictView()
}

// 현재시간 가져오는 함수
func getCurrentDateTime() -> (String, String) {
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

// Flask 통신을 위한 함수(승차인원)
func fetchDataFromServerBoarding(stationName: String, date: String, time: String, stationLine: String, completion: @escaping (String) -> Void) {
    let url = URL(string: "http://localhost:5000/subway")!
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
        }
    }
    task.resume()
}

// Flask 통신을 위한 함수(하차인원)
func fetchDataFromServerAlighting(stationName: String, date: String, time: String, stationLine: String, completion: @escaping (String) -> Void) {
    print(stationName,date,time,stationLine)
    let url = URL(string: "http://localhost:5000/subwayAlighting")!
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
            print(responseString)
        }
    }
    task.resume()
}
// 현재탑승인원 받기(출발역 부터 탑승인원 - 현재인원)


// 현재시간에 "시인원"을 더한 값을 key값으로 서버에서 받아온 JSON값에서 검색해서 값을 가져오는 함수
func getValueForCurrentTime(jsonString: String, currentTime: String) -> Double {
    guard let jsonData = jsonString.data(using: .utf8) else { return 0.0 }
    do {
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            let keyForCurrentTime = "\(currentTime)시인원"
            if let value = json[keyForCurrentTime] as? Double {
                return value
            }
        }
    } catch {
        print("Error parsing JSON:", error)
    }
    return 0.0
}
