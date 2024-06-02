//
//  TodoListDB.swift
//  HaruSijak
//
//  Created by 신나라 on 6/1/24.
//

import Foundation
import SQLite3

class TodoListDB: ObservableObject {
    var db: OpaquePointer?
    var todoList: [TodoLists] = []
    
    init() {
        //DB 경로
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "HaruSijak.sqlite")
        
        // DB 열기
        // 예외 처리
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK{
            print("error opening database")
        }
        
        
        // Table 만들기
        // 예외 처리
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todolist (sid INTEGER PRIMARY KEY AUTOINCREMENT, todo TEXT, startdate TEXT, enddate TEXT, status INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errMsg)")
        }
    }
    
    // 조회
    func queryDB() -> [TodoLists]{
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM todolist"
        
        // 예외 처리
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errMsg)")
        }
        
        // DB에 값 넣기
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(stmt, 0))
            let todo = String(cString: sqlite3_column_text(stmt, 1))
            let startdate = String(cString: sqlite3_column_text(stmt, 2))
            let enddate = String(cString: sqlite3_column_text(stmt, 3))
            let status = Int(sqlite3_column_int(stmt, 4))
            
            // Model에 넣기
            todoList.append(TodoLists(id: id, todo: todo, startdate: startdate, enddate: enddate, status: status))
        }
        
        return todoList
    } // queryDB
    
    
    // 할일 추가
    func insertDB(todo: String, startdate: String, enddate: String, status: Int) -> Bool{
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO todolist (todo, startdate, enddate, status) VALUES (?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, todo, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, startdate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, enddate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 4, Int32(status))
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            return true
        }
        
        return false
    } // insertDB
 
    
    // 수정
    func updateDB(todo: String, startdate: String, enddate: String, id: Int32) -> Bool{
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE todolist SET todo=?, startdate=?, enddate=? WHERE sid=?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, todo, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, startdate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, enddate, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 4, id)
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            return true
        }
        
        return false
    }
    
    
    //할일 삭제
    func deleteDB(id: Int32) -> Bool{
        var stmt: OpaquePointer?
        _ = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "DELETE FROM todolist WHERE sid = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, id)
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            return true
        }
        return false
    }
    
    // status update
    func updateDB(status: Int32, id: Int32) -> Bool{
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE todolist SET status=? WHERE sid=?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, status)
        sqlite3_bind_int(stmt, 2, id)
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            return true
        }
        
        return false
    }
}


