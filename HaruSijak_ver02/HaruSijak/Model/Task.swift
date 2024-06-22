//
//  Task.swift
//  HaruSijak
//
//  Created by 신나라 on 6/10/24.
//

import SwiftUI

//할 일 Model
struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

// 총 할일 데이터
struct TaskMetaData: Identifiable {
//    var id = UUID().uuidString
    var id : String
    var task: [Task]
    var taskDate: Date
}

//테스트를 위한 샘플 날짜
func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}

//
// 샘플 할 일들
var tasks: [TaskMetaData] = [
//    TaskMetaData(task: [
//        Task(title: "수다떨기"),
//        Task(title: "디자인 변경하기"),
//        Task(title: "할일 없음!!!")
//    ], taskDate: getSampleDate(offset: 1)),
//    
//    TaskMetaData(task: [
//        Task(title: "팀쿸과 미팅")
//    ], taskDate: getSampleDate(offset: -8)),
//    
//    TaskMetaData(task: [
//        Task(title: "부의 추월차선 읽기")
//    ], taskDate: getSampleDate(offset: 10)),
//    
//    TaskMetaData(task: [
//        Task(title: "공부하기")
//    ], taskDate: getSampleDate(offset: -22)),
//    
//    TaskMetaData(task: [
//        Task(title: "포트폴리오 작성")
//    ], taskDate: getSampleDate(offset: -20)),
]
