//
//  NewsVM.swift
//  HaruSijak
//
//  Created by G.Zen on 2024-06-17.
//

// MARK: -- Description
/*
    Description : HaruSijack App 개발 News Crawling Page
    Date : 2024. 06. 17. (Mon)
    Author :
    Detail :
    Updates :
        * 2024.06.17. (Mon) by. G.Zen: 기초 Design 구상
 */

import Foundation

struct NewsVM {
  
  func loadData(url: URL, completion: @escaping (Result<[NewsModel], Error>) -> Void) {
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      } // end of if let error 구문
      
      guard let data = data else {
        completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
        return
      } // end of guard let data 구문
      
      do {
        let news = try JSONDecoder().decode([NewsModel].self, from: data)
        completion(.success(news))
        
      } catch {
        completion(.failure(error))
        
      }
      
    }.resume()
    
  } // end of functions loadData(url, completion)
  
} // end of struct NewsVM
