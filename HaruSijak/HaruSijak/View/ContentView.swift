//  Created by 신나라 on 6/1/24.
// MARK: -- Description
/*
    Description : HaruSijack App 개발 contentMain page + tab bar
    Date : 2024.6.1
    Author : Shin  + pdg
    Dtail :
    Update :
        * 2024.06.10 by pdg : 기존 페이지에서 tabbar view 추가 
 */

//

import SwiftUI


struct ContentView: View {
    // MARK: -- properties
    @State private var isPressed = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("하루시작")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                NavigationLink(destination: PredictView()) {
                    ZStack(content: {
                        
                        // 배경 이미지
                        Image(systemName: "tram.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 300)
                            .opacity(0.3)
                        
                        // 버튼 텍스트
                        Text("지하철 혼잡도\n예측보기")
                            .multilineTextAlignment(.center)
                            .frame(width: 320, height: 200)
                            .padding()
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.black)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    })// Z
                }//NL
                
                HStack(content: {
                    NavigationLink(destination: NewsView()) {
                        Text("뉴스\n요약 보기")
                            .frame(width: 140, height: 150)
                            .padding()
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.black)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .scaleEffect(1.0)
                    }
                    NavigationLink(destination: TodoListView()) {
                        Text("TodoList")
                            .frame(width: 140, height: 150)
                            .padding()
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.black)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .scaleEffect(1.0)
                    }//NL
                })//H
                Spacer()
            }// V
        } //NV
    }//View
}


#Preview {
    ContentView()
}
