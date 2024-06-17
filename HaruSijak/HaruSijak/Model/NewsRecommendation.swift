//
//  NewsRecommendation.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import Foundation

struct NewsRecommendation: Codable, Identifiable {
  var id = UUID()  // SwiftUI의 ForEach를 위해 식별자를 추가
  let press: String
  let title: String
  let link: String
  let similarity: Double
} // end of struct NewsRecommendation: Codable, Identifiable
