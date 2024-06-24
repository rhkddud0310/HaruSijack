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
        
        
//            VStack {
//                Spacer()
//                // TabBarview
//                TabView(selection: $selection,content:  {
//                    PredictView()
//                        .tabItem {
//                            Image(systemName: "tram")
//                            Text("혼잡도")
//                        }
//                        .tag(0)
//                    NewsView()
//                        .tabItem {
//                            Image(systemName: "newspaper")
//                            Text("뉴스")
//                        }
//                        .tag(1)
//                    CalendarView()
//                        .tabItem {
//                            Image(systemName: "calendar")
//                            Text("할일")
//                        }
//                        .tag(2)
//                    SettingView()
//                        .tabItem {
//                            Image(systemName: "gearshape")
//                            Text("설정")
//                        }
//                        
//
//                })//TV
//                
//                .tint(Color("color1"))
//                Spacer()
//            }// VS
        
        NavigationView {
            VStack {
                TabView(selection: $selection) {
                    PredictView()
                        .tag(0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    NewsView()
                        .tag(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("오늘의 뉴스")
                        .navigationBarTitleDisplayMode(.large)
                    
                    CalendarView()
                        .tag(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("할 일")
                    
                    SettingView()
                        .tag(3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("설정")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .onAppear {
                    //setupPageControlColors()
                }
                
                // Custom TabBar
                HStack {
                    TabBarButton(icon: "tram", text: "혼잡도", selection: $selection, tag: 0)
                    Spacer()
                    TabBarButton(icon: "newspaper", text: "뉴스", selection: $selection, tag: 1)
                    Spacer()
                    TabBarButton(icon: "calendar", text: "할일", selection: $selection, tag: 2)
                    Spacer()
                    TabBarButton(icon: "gearshape", text: "설정", selection: $selection, tag: 3)
                }
                .padding()
                .background(Color.white)
                .tint(Color("color1"))
            }
        }
    }// Body
    //MARK: FUNCTIONS
    
}// CV

//MARK: Structures



#Preview {
    ContentView()
}
