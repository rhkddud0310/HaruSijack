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
    
    // DateFormatter 전역 변수 설정
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 문자열의 날짜 형식에 맞게 설정
        return formatter
    }
    
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
    
    // SQLite3에서 문자열을 가져와 Date로 변환하는 함수
    func dateFromSQLite(stmt: OpaquePointer, column: Int32) -> Date? {
        if let cString = sqlite3_column_text(stmt, column) {
            let dateString = String(cString: cString)
            return dateFormatter.date(from: dateString)
        }
        return nil
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
            let startdate = dateFromSQLite(stmt: stmt!, column: 2)
            let enddate = dateFromSQLite(stmt: stmt!, column: 3)
            let status = Int(sqlite3_column_int(stmt, 4))
            
            // Model에 넣기
            todoList.append(TodoLists(id: id, todo: todo, startdate: startdate!, enddate: enddate!, status: status))
        }
        
        return todoList
    } // queryDB
    
    
    
    
    
    // 할일 추가
    func insertDB(todo: String, startdate: Date, enddate: Date, status: Int) -> Bool{
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO todolist (todo, startdate, enddate, status) VALUES (?,?,?,?)"
        
        print(todo)
        print(startdate)
        print(enddate)
        print(status)
        
        let startdateString = dateFormatter.string(from: startdate)
        let enddateString = dateFormatter.string(from: enddate)
        
        print(startdateString)
        print(enddateString)
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, todo, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, startdateString, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, enddateString, -1, SQLITE_TRANSIENT)
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


