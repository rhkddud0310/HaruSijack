//
//  CalendarDetailView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/11/24.
//

import SwiftUI

struct CalendarDetailView: View {
    
    @State var task: Task
    @State var currentDate = Date()
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        
        VStack(content: {
            //일정 textfield
            TextField("일정 제목", text: $task.title)
                .font(.title3.bold())
                .frame(width: 200)
                .padding()
                .cornerRadius(8)
                .focused($isTextFieldFocused)
            
            //요일 설정 picker
//            DatePicker(
//                "요일 설정 : ",
//                selection: $dateValue,
//                displayedComponents: [.date]
//            )
//            .frame(width: 200)
//            .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어로 설정
//            .tint(Color("color1"))
            
            //시간 설정 picker
            DatePicker(
                "시간 설정 : ",
                selection: $task.time,
                displayedComponents: [.hourAndMinute]
            )
            .frame(maxWidth: 200)
            .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어로 설정
            .tint(Color("color1"))
        })
    }
}
//
//#Preview {
//    CalendarDetailView(task: Task(id: "010101", title: "title"))
//}
