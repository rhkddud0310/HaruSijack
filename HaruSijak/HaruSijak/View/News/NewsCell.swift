//
//  NewsCell.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import SwiftUI

struct NewsCell: View {
  // Property
  let news: NewsRecommendation
  
  var body: some View {
    
    VStack(alignment: .leading) {
      Text(news.press)
        .font(.headline)
        .padding([.top, .leading, .trailing])
      Text(news.title)
        .font(.subheadline)
        .padding([.leading, .bottom, .trailing])
    } // end of VStack
    .background(Color.white)
    .cornerRadius(8)
    .shadow(radius: 4)
    .padding([.top, .horizontal])
    
  } // end of var body: some View
} // end of struct NewsCell: View
