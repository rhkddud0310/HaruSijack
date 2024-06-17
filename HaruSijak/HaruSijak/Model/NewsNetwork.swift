//
//  NewsNetwork.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import Foundation

class NewsNetwork {
  // Property
  static let shared = NewsNetwork()
  
  private init() {}
  
  func fetchNewsRecommendations(completion: @escaping ([NewsRecommendation]?) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/news_recommendations") else {
      completion(nil)
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        print("Error fetching recommendations: \(error)")
        completion(nil)
        return
      }
      
      guard let data = data else {
        completion(nil)
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let recommendations = try decoder.decode([NewsRecommendation].self, from: data)
        completion(recommendations)
      } catch {
        print("Error decoding JSON: \(error)")
        completion(nil)
      }
    }
    
    task.resume()
  } // end of functions fetchNewsRecommendations(completion)
} // end of class NewsNetwork
