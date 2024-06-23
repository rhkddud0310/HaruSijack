//
//  PredictView_ver2.swift
//  HaruSijak
//
//  Created by 박동근 on 6/22/24.
//

import SwiftUI
import Zoomable
import Charts

struct PredictView_ver2: View {
    
    
    
    @State private var magnifyBy = 1.0
    var magnification: some Gesture {
      MagnifyGesture()
//            .updating($magnifyBy){value, gestureState,transaction in
//                gestureState = value.magnification
//            }
            .onChanged{ value in
                magnifyBy = value.magnification
                
            }
    }
    
    var body: some View {
        Text("hello ")
//        Circle()
//            .frame(width: 100, height: 100)
//            .scaleEffect(magnifyBy)
//            .gesture(magnification)
        ScrollView([.horizontal,.vertical],
            content: {
            Image("subwayMap")
                .resizable()
                .scaleEffect(magnifyBy)
                .gesture(magnification)
        })
        .scaleEffect(magnifyBy)
        .gesture(magnification)
        
    }
}

struct scrollViewImage_01 : View {
    let line5 = SubwayList().stations_line5
    
    // 지하철 노선도 사이즈
    let image = UIImage(named: "subwayMap")
    let imgWidth = UIImage(named: "subwayMap")!.size.width
    let imgHight = UIImage(named: "subwayMap")!.size.height
    var body: some View {
        Text("\(image!.size.width),\(image!.size.height)")
        ScrollView([.horizontal, .vertical],
                   showsIndicators: false,
                   content: {
            Image("subwayMap")
                .resizable()
                .frame(width: imgWidth, height: imgHight)
                .aspectRatio(contentMode: .fit)
            
                .overlay(
                    GeometryReader {geometry in
                        ForEach(line5, id: \.0) { station in
                            Button(action: {
                                print("button clicked")
                                
                                
                            }){
                                Text("\(station.0)")
                                    .frame(minWidth: 30)
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                            }
                            .position(x:station.2, y:station.1)
                            
                            }// FE
                    }//GR
                )// Overlay

//                .scaleEffect(magnifyBy)
//                .gesture(magnification)
                
            
        })//SV
    }
}
#Preview {
    PredictView_ver2()
}
