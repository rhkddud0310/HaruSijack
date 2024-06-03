//
//  TodoLists.swift
//  HaruSijak
//
//  Created by 신나라 on 6/1/24.
//

import Foundation

struct TodoLists{
    var id: Int
    var todo: String
    var startdate = Date()
    var enddate = Date()
    var status: Int
    
    init(id: Int, todo: String, startdate: Date = Date(), enddate: Date = Date(), status: Int) {
        self.id = id
        self.todo = todo
        self.startdate = startdate
        self.enddate = enddate
        self.status = status
    }
}

extension TodoLists: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
