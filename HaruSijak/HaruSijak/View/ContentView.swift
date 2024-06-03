//
//  ContentView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/1/24.
//

import SwiftUI


struct ContentView: View {
    
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
//                            .scaleEffect(isPressed /*? 0.95 : 1.0)*/
                        
                        
                    })
                }
                
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
                        
                    }
                    
                })
                
                
                
                Spacer()
            }
        }
    }
}


#Preview {
    ContentView()
}
