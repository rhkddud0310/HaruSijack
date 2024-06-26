//
//  CustomDatePicker.swift
//  HaruSijak
//
//  Created by 신나라 on 6/10/24.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0 // 화살표버튼 클릭 시 월 update
    
    var body: some View {
        
        //요일 리스트
        let days: [String] = ["일","월","화","수","목","금","토"]
        
        VStack(spacing: 35, content: {
            
            //년도, 월 나타내기
            HStack(spacing: 20 ,content: {
                VStack(alignment: .leading, spacing: 10 ,content: {
                
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("\(extraDate()[1])월")
                        .font(.title.bold())
                })//VStack
                
                Spacer(minLength: 0)
                
                //이전버튼 : month -1 처리
                Button(action: {
                    withAnimation{
                        currentMonth -= 1
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                
                //다음버튼 : month +1 처리
                Button(action: {
                    withAnimation{
                        currentMonth += 1
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                })
                
            })//HStack
            .padding()
            
            // 요일 나타내기
            HStack(spacing: 0 ,content: {
                ForEach(days, id: \.self) {day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
            })//HStack
            
            
            // 날짜 가져오기
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15, content: {
                ForEach(extraDate()) {value in
                    CardView(value: value)
                }
            }) //LazyVGrid
        })//VStack
        
        //월 update 처리하기
        .onChange(of: currentMonth) {
            currentDate = getCurrentMonth()
        }
        
    }// body
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack(content: {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3.bold())
            }
        })
    }
    
    
    /* 년도와 월 정보 가져오기 */
    func extraDate() -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM" //2024 06로 반환
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    /* 현재 Month 가져오기 */
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    
    /* 날짜 요소 뽑기 함수 */
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
        print("firstWeekday : ",firstWeekday)
        
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
        print("calendar : ", calendar)
        
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


