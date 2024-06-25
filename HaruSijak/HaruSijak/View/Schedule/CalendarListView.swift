//
//  CalendarAddView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/25/24.
//

import SwiftUI

struct CalendarListView: View {
    
    @State var currentDate: Date = Date()
    @State var tasksForSelectedDate: [Task]
    @State var isPresented: Bool = false
    @State var selectedTask: Task? = nil // ForEach로 생성된 리스트의 task 값을 담을 변수
    
    let dbModel = CalendarDB()
    
    var body: some View {
        VStack(content: {
            
            HStack {
                Text(dateToString(currentDate))
                    .font(.title.bold())
                .foregroundStyle(.gray)
                
                Spacer()    //왼쪽정렬을 위한 Spacer()
            }// HStack
            .padding(30)
            
            VStack(content: {
                if !tasksForSelectedDate.isEmpty {
                    ForEach(tasksForSelectedDate) {task in
                        
                        // ScrollView 추가!!!
                        VStack(content: {
                            Text(task.time, style: .time)
                            Text(task.title)
                                .font(.title2.bold())
                        })
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .foregroundStyle(task.status == 0 ? Color.black : Color.gray)
                        .background(
                            Color("color2")
                                .cornerRadius(10)
                        )
                    }
                }
            })//VStack
            .onAppear(perform: {
                fetchTasksForSelectedDate()
            })
            
            Spacer()
            
        })
        .padding(.top, 40)
    }
    
    
    /* MARK: 함수시작 */
    // Date to String 변환 함수 추가
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEE"
        return dateFormatter.string(from: date)
    }
    
    /* MARK: task 정보 가져오기 */
    func fetchTasksForSelectedDate() {
        tasksForSelectedDate.removeAll()
        let taskMetaData = dbModel.queryDB().filter{ isSameDay(date1: $0.taskDate, date2: currentDate) }
        if let taskList = taskMetaData.first {
            tasksForSelectedDate = taskList.task
        }
    }
    
    /* MARK: 날짜 체크 */
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}


#Preview {
    let tasks: [Task] = [Task(title: "task1", status: 0)]
    return CalendarListView(tasksForSelectedDate: tasks)
}

