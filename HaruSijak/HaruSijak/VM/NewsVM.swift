//
//  NewsVM.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import Foundation

struct NewsVM {
  
  /*
      async, await 방식으로 JSON Data 연결하는 로직
   */
  func loadData (url: URL) async throws -> [NewsModel] {
    /*
        shared : Singleton Session Object
     */
    let (data, _) = try await URLSession.shared.data(from: url)
    
    return try JSONDecoder().decode([NewsModel].self, from: data)
    
  } // end of functions loadData()
  
} // end of struct NewsVM
