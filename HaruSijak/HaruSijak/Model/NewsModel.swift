//
//  NewsRecommendation.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import Foundation

struct NewsModel: Decodable {
  
  // MARK: * Property *
//  var id = UUID() // SwiftUI의 ForEach를 위해 식별자를 추가
  let Link: String
  let Press: String
  let Title: String
  
} // end of struct NewsModel: Decodable

//****************************************************************************************************************************
extension NewsModel: Hashable {
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(Title)
  } // end of functions hash(into, inout)
  
} // end of extension NewsModel: Hashable
//****************************************************************************************************************************

