//
//  TimeSettingDB.swift
//  HaruSijak
//
//  Created by 신나라 on 6/12/24.
//
/*
    Description : 2024.06.12 snr : 시간대 설정 DB 생성
 */

import Foundation
import SQLite3

class TimeSettingDB: ObservableObject {
    var db: OpaquePointer?
    var settingList: [Time] = []
    
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true ).appending(path: "HaruSetting.sqlite")
        
        // DB 열기
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK{
            print("error opening database")
            return
        }
        // Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS timeset (id INTEGER PRIMARY KEY AUTOINCREMENT, time INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errMsg)")
            return
        }
        print("Database and table created successfully")
    }
    
    // 시간대 조회 쿼리
    func queryDB() -> [Time] {
        
        settingList = []
        
        var stmt: OpaquePointer?
        let queryString = "select * from timeset"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errMsg)")
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let time = Int(sqlite3_column_int(stmt, 1))
            
            settingList.append(Time(id: id, time: time))
        }
        
        return settingList
    }// queryDB
    
    
    // 시간대 입력 쿼리
    func insertDB(time: Int) {
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO timeset (time) VALUES (?)"
        
        print("-------------")
        print("time : ", time)
        print("-------------")
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, Int32(time))
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("insert 성공")
        } else {
            print("insert 실패!")
        }
    }
    
    // 시간대 수정 쿼리
    func updateDB(time: Int, id: Int) {
        var stmt: OpaquePointer?
        //let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE timeset SET time=? where id = ?"
        
        print("-------------")
        print("time : ", time)
        print("id : ", id)
        print("-------------")
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_int(stmt, 1, Int32(time))
        sqlite3_bind_int(stmt, 2, Int32(id))
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("update 성공")
        } else {
            print("update 실패!")
        }
    }
}
