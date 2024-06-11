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
                Spacer()
                Text("하루시작")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
                // TabBarview
                TabView(selection: $selection,content:  {
                        Group(content: {
                            PredictView()
                                .tabItem {
                                    Image(systemName: "tram")
                                    Text("혼잡도")
                                }
                                .tag(0)
                            NewsView()
                                .tabItem {
                                    Image(systemName: "newspaper")
                                    Text("뉴스")
                                }
                                .tag(1)
                            CalendarView()
                                .tabItem {
                                    Image(systemName: "calendar")
                                    Text("할일")
                                }
                                .tag(2)
                            SettingView()
                                .tabItem {
                                    Image(systemName: "gearshape")
                                    Text("설정")
                                }
                        })//G
                        .toolbarBackground(.visible, for: .tabBar)

                })//TV
                Spacer()
            }// VS
        } //NV
    }// Body
    //MARK: FUNCTIONS
    
}// CV

//MARK: Structures



#Preview {
    ContentView()
}
