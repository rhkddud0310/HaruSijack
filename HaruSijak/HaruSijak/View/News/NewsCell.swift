//
//  NewsCell.swift
//  HaruSijak
//
//  Created by G.Zen on 2024-06-17.
//

// MARK: -- Description
/*
    Description : HaruSijack App 개발 News Crawling Page
    Date : 2024. 06. 16. (Sun)
    Author :
    Detail :
    Updates :
        * 2024.06.16. (Sun) by. G.Zen: 기초 Design 구상
 */

import SwiftUI

struct NewsCell: View {
  
  // MARK: * Property *
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
