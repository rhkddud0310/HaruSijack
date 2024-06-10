//
//  CalendarView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/10/24.
//

import SwiftUI

struct CalendarView: View {
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) { // showsIndicators : false => 스크롤바 안보이게
            
            VStack(spacing: 20, content: {
                
                //Custom Picker View
                CustomDatePicker(currentDate: $currentDate)
                
            })//VStack
            .padding(.vertical)
        }//ScrollView
        .safeAreaInset(edge: .bottom, content: {
            HStack(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .frame(width: 100)
                        .padding(.vertical)
                        .background(Color(.blue), in: Circle())
                })
            })
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .padding(.top, 10)
            
        })
    }
}

#Preview {
    CalendarView()
}
