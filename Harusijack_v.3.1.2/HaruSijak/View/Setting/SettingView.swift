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
                              시간 선택 picker를 TimeSettingView로 view로 생성함 -> 다른페이지에서도 사용하기 위해
 
        * 2024.06.17 by snr : 시간설정 + 출발역 지정 기능 추가하기
        * 2024.06.27 by pdg : 시간 설정 칸 이랑 버전 정보랑 구분이 안감. -> 시간 설정은 버튼화 했으면 좋겠음.
 
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
    @State var stationName: String
    @State var line: Int
    @State var time: Int
    
    

    var body: some View {
            //NavigationView
            VStack(content: {
                //출근 시간대 설정하기
                HStack(content: {
                    Button(action: {
                        isShowSheet = true
                    },
                           label: {
                        Image(systemName: "slider.horizontal.2.square")
                            .font(.system(size: 25))
                            .padding()
                        
                        Text("출발역, 시간대 설정하기")
                    })
                    
                })
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading, 20)
                .onTapGesture {
                    isShowSheet = true
                }
                
                VStack(content: {
                    if let firstResult = dbModel.queryDB().first {
                        Text("[출발역 : \(firstResult.station)역 [\(firstResult.line)호선], 설정시간 : \(firstResult.time)시]") // 저장되어있는 설정시간 보여주기
                            .foregroundStyle(.gray)
                    }
                })
                
                // 버전정보 출력
                HStack(content: {
                    Image(systemName: "v.square")
                        .font(.system(size: 25))
                        .padding()
                    
                    Text("버전정보 : v.1.0.0")
                })
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading, 20)
                
                Spacer()
                
            })//Vstack
            .padding(.top, 30)
//            .font(.custom("Ownglyph_noocar-Rg", size: 20))
            
            
            // 시간설정 sheet
////            .sheet(isPresented: $isAlert, onDismiss: {
//                    fetchTasksForSelectedDate()
//                }, content: {
//                    CalendarAddView(currentDate: currentDate)
//                        .presentationDetents([.medium])
//                        .presentationDragIndicator(.visible)
//                })
            .sheet(isPresented: $isShowSheet, content: {
                TimeSettingView(titleName: "출발역, 시간대 설정하기", stationValue: $stationName, lineValue: $line)
                    .onDisappear{
                        fetchTasksForSelectedDate()
                    }
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
            })//sheet
        
    }
    
    
    /* MARK: 설정 값 reload 함수*/
    func fetchTasksForSelectedDate(){
        guard let result = dbModel.queryDB().first else { return }
        stationName = result.station
        time = result.time
        line = result.line
    }
}

//#Preview {
//    SettingView(stationName: "가디", line: 1, time: 1)
//}
