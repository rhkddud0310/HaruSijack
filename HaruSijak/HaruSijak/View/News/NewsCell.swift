//
//  NewsCell.swift
//  HaruSijak
//
//  Created by Gwangyeong Kim on 2024-06-17.
//

import SwiftUI

struct NewsCell: View {
  // Property
//  let news: NewsModel
  let newsTitle: String
  let newsPress: String
  
  var body: some View {
    
    VStack(alignment: .leading) {
      Text(newsPress)
        .font(.headline)
        .padding([.top, .leading, .trailing])
      Text(newsTitle)
        .font(.subheadline)
        .padding([.leading, .bottom, .trailing])
    } // end of VStack
    .background(Color.white)
    .cornerRadius(8)
    .shadow(radius: 4)
    .padding([.top, .horizontal])
    
  } // end of var body: some View
} // end of struct NewsCell: View
