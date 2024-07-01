//  Created by 신나라 on 6/1/24.
// MARK: -- Description
/*
    Description : HaruSijack App 개발 contentMain page + tab bar
    Date : 2024.6.1
    Author : Shin  + pdg
    Dtail :
    Updates :
        * 2024.06.10 by pdg : 기존 페이지에서 tabbar view 추가 
            - 프로그램 코드 기본 주석, 포맷 작성
            - tabbar 생성
        * 2024.06.11 by snr : Add tabbar icon for settingPage
 */

//

import SwiftUI
struct ContentView: View {
    
    // MARK: -- properties
    @State private var isPressed = false
    @State var selection = 0
    
    
    // MARK: -- body
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $selection) {
                    PredictView04()
                        .tag(0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    NewsView()
                        .tag(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        .navigationTitle("오늘의 뉴스")

                    CalendarView()
                        .tag(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("할 일")

                    SettingView(stationName: "가디", time: 0)

                        .tag(3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("설정")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 페이지 인디케이터 숨기기
                // Custom TabBar
                HStack {
                    
                    TabBarButton(icon: "tram", text: "혼잡도", selection: $selection, tag: 0)
                        .padding(.leading)
                    Spacer(minLength: 10)
                    TabBarButton(icon: "newspaper", text: "뉴스", selection: $selection, tag: 1)
                    Spacer()
                    TabBarButton(icon: "calendar", text: "할일", selection: $selection, tag: 2)
                    Spacer()
                    TabBarButton(icon: "gearshape", text: "설정", selection: $selection, tag: 3)
                        .padding(.trailing)
                }
                .padding()
            }
        }
    }// Body
}// CV

//MARK: Structures



#Preview {
    ContentView()
}
