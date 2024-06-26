//
//  magnification.swift
//  testscroll
//
//  Created by ji-hwan park on 6/21/24.
//

import SwiftUI

struct magnification: View {
    @State private var magnifyBy = 1.0
    
    let stations = [
        ("장암", 80.0, 163.0),
        ("도봉산", 135.0, 164.0),
        ("수락산", 189.0, 161.0),
        ("마들", 245.0, 164.0),
        ("노원", 298.0, 162.0),
        ("중계", 351.0, 161.0),
        ("하계", 407.0, 162.0),
        ("공릉", 462.0, 161.0),
        ("태릉입구", 513.0, 158.0),
        ("먹골", 567.0, 162.0),
        ("중화", 623.0, 162.0),
        ("상봉", 674.0, 161.0),
        ("면목", 730.0, 161.0),
        ("사가정", 710.0, 300.0),
        ("용마산", 645.0, 301.0),
        ("중곡", 581.0, 300.0),
        ("군자", 514.0, 299.0),
        ("어린이대공원", 451.0, 298.0),
        ("건대입구", 385.0, 299.0),
        ("뚝섬유원지", 319.0, 300.0),
        ("청담", 257.0, 300.0),
        ("강남구청", 187.0, 300.0),
        ("학동", 124.0, 300.0),
        ("논현", 61.0, 298.0),
        ("반포", 63.0, 450.0),
        ("고속터미널", 129.0, 452.0),
        ("내방", 194.0, 454.0),
        ("이수", 257.0, 452.0),
        ("남성", 324.0, 451.0),
        ("숭실대입구", 387.0, 454.0),
        ("상도", 453.0, 453.0),
        ("장승배기", 519.0, 452.0),
        ("신대방삼거리", 585.0, 452.0),
        ("보라매", 648.0, 450.0),
        ("신풍", 714.0, 453.0),
        ("대림", 712.0, 614.0),
        ("남구로", 648.0, 612.0),
        ("가산디지털단지", 580.0, 613.0),
        ("철산", 518.0, 613.0),
        ("광명사거리", 451.0, 611.0),
        ("천왕", 388.0, 611.0),
        ("온수", 322.0, 612.0)
    ]
      
      var magnification: some Gesture {
        MagnifyGesture(minimumScaleDelta: magnifyBy)
          .onChanged { value in
            magnifyBy = value.magnification
          }
      }
      
      var body: some View {
          ScrollView([.horizontal, .vertical]) {
              Image("Line7") // 예시로 이미지 사용
                  .resizable()
//                  .frame(width: 1200,height: 1400)
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 800, height: 800)
                  
                  .overlay(GeometryReader { geometry in
                      ForEach(stations, id: \.0) { station in
                          Button(action: {
                              print("버튼 눌a림")
                          }) {
                              Text("")
                                  .frame(width: 20, height: 20)
                                  .background(Color.red)
                          }
                          .position(x: CGFloat(station.1), y: CGFloat(station.2))
                      }
                  })
                  .scaleEffect(magnifyBy)
                  .gesture(magnification)
                    
          }
      }
}

#Preview {
    magnification()
}
