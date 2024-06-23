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
    let line5 = SubwayList().stations_line5
    let image = UIImage(named: "subwayMap")
    
    let imgWidth = UIImage(named: "subwayMap")!.size.width
    let imgHight = UIImage(named: "subwayMap")!.size.height
    
    
    var body: some View {
//        Text("\(sublist.stations_line5[0].0)")
        Text("\(image!.size.width),\(image!.size.height)")
        ScrollView([.horizontal, .vertical],
                   showsIndicators: false,
                   content: {
            Image("subwayMap")
                .resizable()
                .frame(width: imgWidth, height: imgHight)
                .overlay(
                    GeometryReader {geometry in
                        ForEach(line5, id: \.0) { station in
                            Button(action: {
                                print("button clicked")
                            }, label: {
                                Text("")
                                    .background(Color.red)
                                
                            }
                                
                            )}
                        
                        
                    }
                )
            
        })
        
        
    }
}

#Preview {
    PredictView_ver2()
}
