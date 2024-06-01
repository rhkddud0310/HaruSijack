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
                    
                NavigationLink(destination: PredictView()) {
                    Text("혼잡도 예측보기")
                        .frame(width: 320, height: 200)
                        .padding()
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.black)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .scaleEffect(1.0)
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
            .navigationTitle("하루시작")
        }
    }
}


#Preview {
    ContentView()
}
