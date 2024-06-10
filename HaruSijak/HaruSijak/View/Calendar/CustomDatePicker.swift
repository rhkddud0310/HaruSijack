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
                    
                    Text("2024")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("6월")
                        .font(.title.bold())
                })//VStack
                
                Spacer(minLength: 0)
                
                //이전버튼
                Button(action: {
                    
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                
                //다음버튼
                Button(action: {
                    
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
                    Text("\(value.day)")
                        .font(.title3.bold())
                }
            }) //LazyVGrid
            
        })//VStack
    }// body
    
    func extraDate() -> [DateValue] {
     
        let calendar = Calendar.current
        //date(byAdding:, value:, to: ) : Date주어진 날짜에 구성 요소를 추가하여 계산된 날짜를 나타내는 새 날짜를 반환
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return [] }
        
        return currentMonth.getAllDates().compactMap{date -> DateValue in
            
            //요일 가져오기
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
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
        
        //range(of:in:for) =>
        // of : 더 작은 달력 구성요소
        // in : 더 큰 달력 구성요소
        // date : 계산이 수행되는 절대 시간
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        //date 가져오기
        
        //compactMap : nil값은 알아서 제거해서 보여준다.
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day, to: self)!
        }
    }
}


