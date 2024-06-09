//
//  TodoListView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/1/24.
//

import SwiftUI

struct TodoListView: View {
    
    @State var todoLists: [TodoLists] = []
    
    let todayDate = Date.now
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {

        VStack {
            
//            Text("TodoList")
//                .font(.system(.largeTitle, design: .rounded))
//                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            NavigationView(content: {
                List(content: {
                    ForEach(todoLists, id:\.id, content: { todoList in
                        NavigationLink(destination: DetailTodoListView(todoList: todoList), label: {
                            VStack(alignment:.leading ,content: {
                                Text(todoList.todo)
                                    .font(.system(size: 14))
                                    .bold()
                                
                                HStack(content: {
                                    Text(dateFormatter.string(from: todoList.startdate))
                                    Text("-")
                                    Text(dateFormatter.string(from: todoList.enddate))
                                })
                                .foregroundStyle(todoList.status == 1 ? Color.black.opacity(0.3) : Color.black)
                                .padding(.top, 5)
                                .font(.system(size: 12))
                            })//Vstack
                        })// NavigationLink
                    })//ForEach
                })// List
                .onAppear(perform: {
                    todoLists.removeAll() //지우고
                    let todoListDB = TodoListDB() // DB instance 생성
                    todoLists = todoListDB.queryDB() //VM에 있는 쿼리 실행
                })
                .navigationTitle("TodoList")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                //추가 아이콘
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        // 할일 추가로 이동
                        NavigationLink(destination: AddTodoListView()) {
                            Image(systemName: "plus")
                                .padding(.trailing, 10)
                            
                        } // NavigationLink
                    }) // ToolbarItem
                })
            })
        }// NavigationView
    }
}

#Preview {
    TodoListView()
}
