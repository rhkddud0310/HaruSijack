//
//  PredictView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/1/24.
//  Description : 지하철 혼잡도 예측 페이지

import SwiftUI
import Zoomable

struct PredictView: View {
    
    @State var stationName: String = ""
    var bgColor: Color = Color.red
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        
        
        VStack {
            
            Spacer()
            
            // 검색창 TextField
            HStack(content: {
                TextField("지하철 7호선 역명, 초성 검색", text : $stationName)
                    .padding()
                    .frame(width: 280)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                    .keyboardType(.default)
                    .focused($isTextFieldFocused)
                
                // 검색버튼
                Button(action: {
                    //action
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                })//Button
            })//Hstack
            
           ZStack(content: {
               
               //스크롤뷰 [노선도 사진]
               ScrollView(.vertical, showsIndicators: false , content: { //showsIndicators : 스크롤바 안보이게
                   ScrollView(.horizontal, showsIndicators: false ,content: {
                      Image("line73")
                           .resizable()
                           .frame(width: 1500, height: 1000)
                           .zoomable() // double click시 화면 확대
                   })
                   .frame(maxWidth: .infinity)
               })//ScrollView
               
                Button(action: {
                    stationName = "장암"
                    print("장암")
                }, label: {
                    Text("T")
                        .frame(width: 20, height: 20)
                        .background(bgColor)
                        .clipShape(Circle())
                })
                .offset(x: 465, y : 430)
               
               
                
           })// Zstack
            
            
        } //Vstack
        
        
        
    } //body
        
}

#Preview {
    PredictView()
}
