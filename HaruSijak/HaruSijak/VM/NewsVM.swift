//
//  NewsVM.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
  @Published var recommendations: [NewsRecommendation] = []
  
  init() {
    fetchRecommendations()
  } // end of init()
  
  func fetchRecommendations() {
    NewsNetwork.shared.fetchNewsRecommendations { [weak self] recommendations in
      DispatchQueue.main.async {
        self?.recommendations = recommendations ?? []
      }
    }
  } // end of functions fecthRecommendations()
} // end of class NewsViewModel: ObservableObject
