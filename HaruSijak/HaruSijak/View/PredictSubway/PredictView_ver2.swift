//
//  PredictView_ver2.swift
//  HaruSijak
//
//  Created by 박동근 on 6/22/24.
//

import SwiftUI

struct PredictView_ver2: View {
    let sublist = SubwayList()
    
    
    var body: some View {
        Text("\(sublist.stations_line5[0].0)")
        Text("test")
        Image("subwayMap")
    }
}

#Preview {
    PredictView_ver2()
}
