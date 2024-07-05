//
//  TimeSettingView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/13/24.
// 2024.07.05 snr : 호선과 역명 설정되도록 수정

import SwiftUI

struct TimeSettingView: View {
    
//    @State var isShowSheet: Bool = false    // 시간 변경 sheet alert
    let timeList = [Int](5..<25)            // 5~24까지 리스트
    @State var selectedTime = 0             // picker뷰 선택 value
    let dbModel = TimeSettingDB()           // 시간 설정 vm instance 생성
    @State var infoList: [Time] = []        // 조회된 시간정보 담을 리스트
    @Environment(\.dismiss) var dismiss         // 화면 이동을 위한 변수
    @State var alertType: SettingAlertType?        // 추가, 수정 alert
    @State var titleName : String
    @State var selectedStation = 0          // station 선택 value
    @State var selectedLine = 0             // line 선택 value
    @State var line: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    @Binding var stationValue: String 
    @Binding var lineValue: Int
    
    
    let line23 = SubwayList().totalStation
    
    var filteredStatioins: [(String, Int)] {
        line23.map { ($0.name, $0.intValue1) }
            .filter { $0.1 == selectedLine + 1 }
            .sorted { $0.0 < $1.0 }
    }
    
    
    // 역과 버튼위치 정보
//    let stations = [
//        ("장암", 80.0, 163.0),
//        ("도봉산", 135.0, 164.0),
//        ("수락산", 189.0, 161.0),
//        ("마들", 245.0, 164.0),
//        ("노원", 298.0, 162.0),
//        ("중계", 351.0, 161.0),
//        ("하계", 407.0, 162.0),
//        ("공릉", 462.0, 161.0),
//        ("태릉입구", 513.0, 158.0),
//        ("먹골", 567.0, 162.0),
//        ("중화", 623.0, 162.0),
//        ("상봉", 674.0, 161.0),
//        ("면목", 730.0, 161.0),
//        ("사가정", 710.0, 300.0),
//        ("용마산", 645.0, 301.0),
//        ("중곡", 581.0, 300.0),
//        ("군자", 514.0, 299.0),
//        ("어린이대공원", 451.0, 298.0),
//        ("건대입구", 385.0, 299.0),
//        ("뚝섬유원지", 319.0, 300.0),
//        ("청담", 257.0, 300.0),
//        ("강남구청", 187.0, 300.0),
//        ("학동", 124.0, 300.0),
//        ("논현", 61.0, 298.0),
//        ("반포", 63.0, 450.0),
//        ("고속터미널", 129.0, 452.0),
//        ("내방", 194.0, 454.0),
//        ("이수", 257.0, 452.0),
//        ("남성", 324.0, 451.0),
//        ("숭실대입구", 387.0, 454.0),
//        ("상도", 453.0, 453.0),
//        ("장승배기", 519.0, 452.0),
//        ("신대방삼거리", 585.0, 452.0),
//        ("보라매", 648.0, 450.0),
//        ("신풍", 714.0, 453.0),
//        ("대림", 712.0, 614.0),
//        ("남구로", 648.0, 612.0),
//        ("가산디지털단지", 580.0, 613.0),
//        ("철산", 518.0, 613.0),
//        ("광명사거리", 451.0, 611.0),
//        ("천왕", 388.0, 611.0),
//        ("온수", 322.0, 612.0),
//        
//    ]
//    
    
    var body: some View {
            VStack(content: {
                
                //title
                Text(titleName)
                    .font(.custom("Ownglyph_noocar-Rg", size: 30).bold())
                    .padding(.top, 20)
                
                
                
                // ---------------- line picker -------------------
                HStack {
                    Text("호선 선택 : ")
                        .font(.custom("Ownglyph_noocar-Rg", size: 20))
                    
                    Picker("", selection: $selectedLine, content: {
                        ForEach(0..<line.count, id:\.self, content: { index in
                            Text("\(line.map{$0}.sorted()[index])호선").tag(index)
                                .font(.custom("Ownglyph_noocar-Rg", size: 30))
                        })
                    })
                    .pickerStyle(.menu)
                }
                .padding(.top, 40)
                
                
                
                // ---------------- station picker -------------------
                HStack {
                    Text("역 선택 : ")
                        .font(.custom("Ownglyph_noocar-Rg", size: 20))
                    
                    Picker("", selection: $selectedStation, content: {
                        ForEach(filteredStatioins.indices, id: \.self) { index in
                            Text(self.filteredStatioins[index].0).tag(index)
                        }
                        .pickerStyle(MenuPickerStyle())
                    })
                    .pickerStyle(.menu)
                }
                .padding(.top, 10)
                
                
                // ---------------- time picker -------------------
                Picker("", selection: $selectedTime, content: {
                    ForEach(0..<timeList.count, id:\.self, content: { index in
                        Text("\(timeList[index])시").tag(index)
                            .font(.custom("Ownglyph_noocar-Rg", size: 30))
                    })
                })
                .pickerStyle(.wheel)
                
                // ---------------- 변경 button -------------------
                Button("변경하기", action: {
                    infoList = dbModel.queryDB()
                    
                    print("infoList.count : ",infoList.count)
                    
                    // 시간 설정 정보가 없을 때 => insert
                    if infoList.isEmpty {
                        print("infoList is empty, setting isAdd to true")
                        alertType = .add
                        
                    } else {
                        // update 처리
                        print("infoList is not empty, setting isUpdate to true")
                        alertType = .update
                    }
                }) // Button
                .tint(.white)
                .font(.custom("Ownglyph_noocar-Rg", size: 25))
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .background(Color("color1"))
                .cornerRadius(30)
                .controlSize(.large)
                .frame(width: 200, height: 50) // 버튼의 크기 조정
                .padding(.top, 40)
                .alert(item: $alertType) { alertType in
                    switch alertType {
                    case .add:
                        return Alert(
                            title: Text("알림"),
                            message: Text("\(timeList[selectedTime])시,  \(filteredStatioins[selectedStation].0)역으로 \n 설정하시겠습니까?"),
                            primaryButton: .destructive(Text("확인"), action: {
                                dbModel.insertDB(time: timeList[selectedTime], station: filteredStatioins[selectedStation].0, line: line[selectedLine])
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    case .update:
                        return Alert(
                            title: Text("알림"),
                            message: Text("\(timeList[selectedTime])시, \(filteredStatioins[selectedStation].0)역으로 \n 설정하시겠습니까?"),
                            primaryButton: .destructive(Text("확인"), action: {
                                dbModel.updateDB(time: timeList[selectedTime], station: filteredStatioins[selectedStation].0, line: line[selectedLine], id: infoList[0].id)
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                }
            })//VStack
    }
}

enum SettingAlertType: Identifiable {
    case add
    case update
    
    var id: Int{
        hashValue
    }
}
#Preview {
    TimeSettingView(titleName: "테스트제목", stationValue: .constant("Initial Station Value"), lineValue: .constant(1))
}
