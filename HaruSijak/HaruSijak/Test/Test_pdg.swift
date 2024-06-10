//
//  Test_pdg.swift
//  HaruSijak
//
//  Created by 박동근 on 6/10/24.
//

import SwiftUI

struct Test_pdg: View {
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
            }
            
            Spacer()
        }// VS
    } //NV
}// Body
//MARK: FUNCTIONS



//MARK: Structures


#Preview {
    Test_pdg()
}
