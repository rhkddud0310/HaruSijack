//
//  CalendarAddView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/25/24.
//

import SwiftUI

struct CalendarListView: View {
    
    @State var currentDate: Date = Date()
    @State var tasksForSelectedDate: [Task] = []
    @State var isPresented: Bool = false
    @State var selectedTask: Task? = nil // ForEach로 생성된 리스트의 task 값을 담을 변수
    @State var isAlert: Bool = false
    @Environment(\.dismiss) var dismiss         // 화면 이동을 위한 변수
    
    let dbModel = CalendarDB()
    
    var body: some View {
        VStack {
            HStack {
                Text(dateToString(currentDate))
                    .font(.title.bold())
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            .padding(30)
            
            if !tasksForSelectedDate.isEmpty {
                List {
                    ForEach(tasksForSelectedDate) { task in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(task.time, style: .time)
                                Spacer()
                            }
                            HStack {
                                Text(task.title)
                                    .font(.title2.bold())
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .foregroundStyle(task.status == 0 ? Color.black : Color.gray)
                        .swipeActions(edge: .trailing) {
                           Button(role: .destructive) {
                               if let index = tasksForSelectedDate.firstIndex(where: { $0.id == task.id }) {
                                   deleteTask(at: IndexSet(integer: index))
                               }
                           } label: {
                               Label("삭제", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle()) // 기본 스타일을 제거하여 List를 VStack처럼 보이게 설정
            } else {
                Text("이 날의 일정이 없습니다.")
                    .foregroundStyle(.gray)
            }
            
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
            })
        }
        .onAppear(perform: fetchTasksForSelectedDate)
//        .padding(.top, 40)
    }
    
    /* MARK: 함수시작 */
    // 삭제 기능
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasksForSelectedDate[index]
            dbModel.deleteDB(id: task.id)
            tasksForSelectedDate.remove(at: index)
        }
    }
    
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
        let taskMetaData = dbModel.queryDB().filter { isSameDay(date1: $0.taskDate, date2: currentDate) }
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
