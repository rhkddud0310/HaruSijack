//
//  C_DatePicker.swift
//  HaruSijak
//
//  Created by 신나라 on 6/3/24.
//

import Foundation
import SwiftUI

func showDatePicker(_ title: String, variable: Binding<Date>) -> some View {
    
    HStack(content: {
        Text("\(title) : ")
        
        DatePicker(
            "",
            selection: variable,
            displayedComponents: [.date]
        )
        .frame(width: 150)
        .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어로 설정
        .tint(Color("myColor"))
    })
}
