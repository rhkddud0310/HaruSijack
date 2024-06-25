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
    @State var isAlert: Bool = false
    @Environment(\.dismiss) var dismiss         // 화면 이동을 위한 변수
    
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
            
            //일정 리스트
            VStack(content: {
                if !tasksForSelectedDate.isEmpty {
                    ForEach(tasksForSelectedDate) {task in
                        
                        // ScrollView 추가!!!
                        VStack(content: {
                            HStack(content: {
                                Text(task.time, style: .time)
                                Spacer()
                            })
                            HStack(content: {
                                Text(task.title)
                                    .font(.title2.bold())
                                Spacer()
                            })
                        })
                        .frame(width: 300)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .foregroundStyle(task.status == 0 ? Color.black : Color.gray)
                        .background(
                            Color("color2")
                                .opacity(0.1)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("이 날의 일정이 없습니다.")
                        .foregroundStyle(.gray)
                }
            })//VStack
            .onAppear(perform: {
                fetchTasksForSelectedDate()
            })
            
            Spacer()
            
            Button(action: {
                isAlert = true
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .frame(width: 100)
                    .padding(.vertical)
                    .background(Color(.blue), in: Circle())
            })
            .sheet(isPresented: $isAlert, onDismiss: {
                fetchTasksForSelectedDate()
                
            }, content: {
                CalendarAddView(currentDate: currentDate)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }) //sheet
            
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

