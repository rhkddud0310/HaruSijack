//
//  SettingView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/11/24.
//
// MARK: -- Description
/*
    Description : HaruSijack App 개발 setting page
    Date : 2024.6.11
    Author : snr
    Detail :
    Updates :
        * 2024.06.11 by snr : Add tabbar icon for settingPage
        * 2024.06.12 by snr : 시간대 변경 sheet 생성
        * 2024.06.13 by snr : 시간설정 추가 및 수정기능 완료
 */


import SwiftUI

struct SettingView: View {
    
    @State var isShowSheet: Bool = false    // 시간 변경 sheet alert
    let timeList = [Int](5..<25)            // 5~24까지 리스트
    @State var selectedTime = 0             // picker뷰 선택 value
    let dbModel = TimeSettingDB()           // 시간 설정 vm instance 생성
    @State var infoList: [Time] = []        // 조회된 시간정보 담을 리스트
    @Environment(\.dismiss) var dismiss         // 화면 이동을 위한 변수
    @State var alertType: SettingAlertType?        // 추가, 수정 alert
    
    
    var body: some View {
        NavigationView(content: {
            
            //NavigationView
            VStack(content: {
                HStack(content: {
                    Image(systemName: "clock")
                        .font(.system(size: 25))
                        .padding()
                    
                    Text("시간대 변경하기")
                    
                    if !dbModel.queryDB().isEmpty {
                        Text("[설정시간 : \(dbModel.queryDB()[0].time)시]") //저장되어있는 설정시간 보여주기
                            .foregroundStyle(.gray)
                    }
                })
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading, 50)
                .onTapGesture {
                    isShowSheet = true
                }
                
                
                HStack(content: {
                    Image(systemName: "v.square")
                        .font(.system(size: 25))
                        .padding()
                    
                    Text("버전정보 : v.1.0.0")
                })
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading, 50)
                
                Spacer()
                
            })//Vstack
            .padding(.top, 30)
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.large)
            
            // 시간설정 sheet
            .sheet(isPresented: $isShowSheet, content: {
                VStack(content: {
                    
                    //title
                    Text("시간 변경")
                        .font(.title.bold())
                    
                    // time picker
                    Picker("", selection: $selectedTime, content: {
                        ForEach(0..<timeList.count, id:\.self, content: { index in
                            Text("\(timeList[index])시").tag(index)
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
                                    isShowSheet = false
                                }),
                                secondaryButton: .cancel(Text("취소"))
                            )
                        case .update:
                            return Alert(
                                title: Text("알림"),
                                message: Text("\(timeList[selectedTime])시로 변경하시겠습니까?"),
                                primaryButton: .destructive(Text("확인"), action: {
                                    dbModel.updateDB(time: timeList[selectedTime], id: infoList[0].id)
                                    isShowSheet = false
                                }),
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    }
                })//VStack
            })//sheet
            .presentationDragIndicator(.visible)
        }) //NavigationView
        
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
    SettingView()
}
