//
//  DetailTodoListView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/2/24.
//

import SwiftUI

struct DetailTodoListView: View {
    
    @State var todoList: TodoLists
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetailTodoListView(todoList: TodoLists(id: 001, todo: "밥먹기", status: 0))
}
