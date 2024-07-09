//
//  testJsonDecode.swift
//  HaruSijak
//
//  Created by 박동근 on 7/9/24.
//

import Foundation

struct jsonConverter{
    func StringToJson(jsonData: String) -> (String?, String?, String?){
        let jsonData = jsonData
        
        var STEP1: String?
        var STEP2: String?
        var STEP3: String?
        
        // JSON 데이터에서 괄호 제거
        let trimmedData = jsonData.trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
        
        // 키와 값을 분리
        let pairs = trimmedData.split(separator: ",")
        
        for pair in pairs {
            let keyValue = pair.split(separator: ":")
            let key = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
            let value = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
            
            switch key {
            case "STEP-1":
                STEP1 = value
            case "STEP-2":
                STEP2 = value
            case "STEP-3":
                STEP3 = value
            default:
                break
            }
        }
        
        // 값 출력
        print("STEP-1: \(STEP1 ?? "값 없음")")
        print("STEP-2: \(STEP2 ?? "값 없음")")
        print("STEP-3: \(STEP3 ?? "값 없음")")
        return (STEP1,STEP2,STEP3)
    }
   

}
