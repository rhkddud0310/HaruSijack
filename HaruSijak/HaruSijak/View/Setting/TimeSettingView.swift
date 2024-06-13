//
//  TimeSettingView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/13/24.
//

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
    
    
    var body: some View {
            VStack(content: {
                
                //title
                Text(titleName)
                    .font(.custom("Ownglyph_noocar-Rg", size: 30).bold())
                
                // time picker
                Picker("", selection: $selectedTime, content: {
                    ForEach(0..<timeList.count, id:\.self, content: { index in
                        Text("\(timeList[index])시").tag(index)
                            .font(.custom("Ownglyph_noocar-Rg", size: 30))
                    })
                })
                .pickerStyle(.wheel)
                
                //button
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
                            message: Text("\(timeList[selectedTime])시로 설정하시겠습니까?"),
                            primaryButton: .destructive(Text("확인"), action: {
                                print("Adding time setting")
                                dbModel.insertDB(time: timeList[selectedTime])
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    case .update:
                        return Alert(
                            title: Text("알림"),
                            message: Text("\(timeList[selectedTime])시로 변경하시겠습니까?"),
                            primaryButton: .destructive(Text("확인"), action: {
                                dbModel.updateDB(time: timeList[selectedTime], id: infoList[0].id)
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
    TimeSettingView(titleName: "테스트제목")
}
