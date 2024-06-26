//
//  CustomDatePicker.swift
//  HaruSijak
//
//  Created by 신나라 on 6/10/24.
//
/*
 Description
    - 2024. 06. 11 snr : - insert된 내용을 조회하는 부분의 문제가 있음.
                         - 일정 있는 날짜에 원 표시 : dbModel.queryDB()에서 불러오지 않아서였음
                         - ForEach문에서 id 중복조회된다는 메세지 tasksForSelectedDate.indices를 사용하여 해결
                         - print(), 불필요한 기능 삭제처리
                         - 일정리스트 클릭 시 상세내용 조회 및 수정되도록
    
    - 2024. 06. 12 snr : - navigationView, List 제거
                         - 날짜 클릭 시 Capsule() -> Circle() 모양으로 변경
                            => 비교 후에 삭제 예정
                         - 달력 사이즈 조정
 
    - 2024. 06. 17 snr - 추가 후에 달력에 바로 반영되기 위해서 onDismiss 처리
    - 2024.06.21 snr - 완료 처리 기능 추가
    - 2024.06.25 snr - 달력 수정
                         
 */

import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0 // 화살표버튼 클릭 시 월 update
    let dbModel = CalendarDB()
    @State var title: String = ""
    @State var taskDate: Date = Date()
    @State var tasksForSelectedDate: [Task] = []
    @FocusState var isTextFieldFocused: Bool    // 키보드 focus
    @State var isPresented = false //상세보기 sheet 조회 변수
    @Binding var dateValue : Date
    @State var selectedTask: Task? = nil // ForEach로 생성된 리스트의 task 값을 담을 변수
    
    @State var isAlert = false            // actionSheet 실행
    @State var isSubAlert = false            // subAlert 실행
    @State var isResultTrue = false
    @State var isResultFalse = false
    @State var date: Date = Date()              // 선택된 날짜 변수
    @State var time: Date = Date()              // 선택된 시간 변수
    @State var task: String = ""
    @State var checked: Bool = false            // 완료처리 check 변수
    @State var status: Int = 0                  // 완료 변수
    @State var calendarAlert: Bool = false      // 달력 클릭했을 때 alert
    @State var selectedDate: Date? = nil
    @State var tasksSelectedDate: [TaskMetaData] = []
    
    var body: some View {
        
        //요일 리스트
        let days: [String] = ["일","월","화","수","목","금","토"]
        
        VStack(spacing: 35, content: {
            
            HStack(spacing: 20 ,content: {
                
                // 이전 월 보기 버튼
                Button(action: {
                   withAnimation{
                       currentMonth -= 1
                       updateCurrentMonth()
                   }
               }, label: {
                   Image(systemName: "chevron.left")
                       .font(.title2)
               })
                
                // 년, 월 Text
                Text("\(extraDate()[0])년 \(extraDate()[1])월")
                    .font(.title2.bold())
                    .fontWeight(.semibold)
                    
                
               //다음버튼 : month +1 처리
               Button(action: {
                   withAnimation{
                       currentMonth += 1
                       updateCurrentMonth()
                   }
               }, label: {
                   Image(systemName: "chevron.right")
                       .font(.title2)
               })
                
                Spacer()
                
                
            })//HStack
            .padding()
            .padding(.bottom, 20)
                
            
            // 요일 나타내기
            HStack(spacing: 0 ,content: {
                ForEach(days, id: \.self) {day in
                    Text(day)
                        .font(.callout)
                        .foregroundStyle(day == "일" ? Color(.red) : Color(.black))
                        .fontWeight(day == currentDayOfWeek() ? .bold : .light)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
            })//HStack
            
            
            // 날짜 가져오기
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15, content: {
                ForEach(extraDate()) {value in
                    CardView(value: value)
                        .id(value.id)
                }
            }) //LazyVGrid
        }) //제일 상위 VStack
        //월 update 처리하기
        .onChange(of: currentMonth) {
            updateCurrentMonth()
        }
        .onAppear {
            fetchTasksForSelectedDate()
        }
        .sheet(item: $selectedTask, onDismiss:  {
            fetchTasksForSelectedDate()
        }, content: { task in
            CalendarDetailView(task: task, currentDate: dateValue)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: Binding(        // Binding은 isPresented 파라미터에 전달된다.
            get: { selectedDate != nil },   // selectedDate가 nil이 아니면 시트를 표시하기 위해 true 반환, nil이면 시트를 숨기기 위해서 false 반환한다.
            set: { if !$0 { selectedDate = nil } } // 시트가 닫힐 때 호출된다. 시트가 닫힐 때 selectedDate를 nil로 설정ㄹ
        )) {
            if let selectedDate = selectedDate {
                CalendarListView(currentDate: selectedDate, tasksForSelectedDate: tasksForSelectedDate)
                    .presentationDragIndicator(.visible)
            }
        }
        
    }// body
    
    
    /* MARK: CardView() */
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack(content: {
            if value.day != -1 {
                
                let tasksForSelectedDate = dbModel.queryDB().filter { taskMetaData in
                    isSameDay(date1: taskMetaData.taskDate, date2: value.date)
                }

                Divider()
                Text("\(value.day)")
                    .frame(maxWidth: .infinity, minHeight: 15, maxHeight: .infinity, alignment: .top)
                    .foregroundStyle(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                    .background(
                        Circle()
                            .fill(Color("color2"))
                            .padding(.horizontal, 10)
                            .padding(.bottom, tasksForSelectedDate.isEmpty ? 80 : 0)
                            .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                    )
                
                VStack(spacing: 2) { // Add VStack to ensure equal spacing
                    if let tasks = tasksForSelectedDate.first?.task {
                        ForEach(tasks.prefix(3).indices, id: \.self) { index in
                            let task = tasks[index]
                            ZStack {
                                Rectangle()
                                    .fill(Color("myColor").opacity(0.2))
                                    .frame(width: 50, height: 20)
                                Text(truncatedText(task.title))
                                    .foregroundStyle(.black)
                                    .font(.system(size: 10))
                                    .position(x: 25, y: 10)
                            }
                        }
                        
                        // Add empty ZStacks to maintain the same height
                        if tasks.count < 3 {
                            ForEach(0..<(3 - tasks.count), id: \.self) { _ in
                                ZStack {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 50, height: 20)
                                }
                            }
                        }
                    }
                }
            } else {
                Divider()
            }
        })
        .frame(height: 110, alignment: .top)
        .onTapGesture {
            selectedDate = value.date
        }
    }
    
    // MARK: 텍스트 자르는 함수
    func truncatedText(_ text: String) -> String {
        if text.count > 4 {
            let index = text.index(text.startIndex, offsetBy: 4)
            return String(text[..<index])
        } else {
            return text
        }
    }
    
    // MARK: 현재 요일을 가져오는 함수
    func currentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E" // "E"는 요일의 짧은 형식 (e.g., "월", "화", "수")
        return dateFormatter.string(from: Date())
    }
    
    /* MARK: month 변경 시 다시 조회되도록 */
    func updateCurrentMonth() {
        currentDate = getCurrentMonth()
        fetchTasksForSelectedDate()
    }
    
    /* MARK: 스케줄러 조회 함수 */
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
    
    /* MARK: 년도와 월 정보 가져오기 */
    func extraDate() -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM" //2024 06로 반환
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    /* MARK: 현재 Month 가져오기 */
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    /* MARK: 날짜 요소 뽑기 함수 */
    func extraDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days =  currentMonth.getAllDates().compactMap{date -> DateValue in
            //요일 가져오기
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        //정확한 요일을 얻기위한 offset
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        // 빈 공간 -1로 넣기
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

#Preview {
    CalendarView()
}

// 이번 달 날짜를 얻기위한 extension
extension Date {
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        //시작날짜 정하기
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        //range(of:in:for) =>
        // of : 더 작은 달력 구성요소
        // in : 더 큰 달력 구성요소
        // date : 계산이 수행되는 절대 시간
        // 위에서 설정한 시작날짜로 부터 계산되게 한다.
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        //date 가져오기
        
        //compactMap : nil값은 알아서 제거해서 보여준다.
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day-1, to: startDate)!
        }
    }
}


