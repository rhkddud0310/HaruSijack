//
//  NewsCell.swift
//  HaruSijak
//
//  Created by G.Zen on 2024-06-15.
//

// MARK: -- Description
/*
    Description : HaruSijack App 개발 News Crawling Page
    Date : 2024. 06. 16. (Sun)
    Author :
    Detail :
    Updates :
        * 2024.06.16. (Sun) by. G.Zen: 기초 Design 구상
 
        - 2024.06.26 by pdg, zen : 중간 발표를 위한 review
            * code review 
 */

import SwiftUI

struct NewsView: View {
  
  // MARK: * Property *
  @State var newsList: [NewsModel] = []
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
      
      ScrollView {
        
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(newsList, id: \.self) { news in
            NewsCell(newsTitle: news.Title, newsPress: news.Press)
          } // end of closure ForEach {news in}
          
        } // end of LazyVGrid
        .padding()
        
      } // end of ScrollView
      
      
    .onAppear {
      
      let newsVM = NewsVM()
      
      newsVM.loadData(url: URL(string: "http://127.0.0.1:5000/news")!) { result in
        switch result {
        case .success(let news):
          DispatchQueue.main.async {
            newsList = news
          }
        case .failure(let error):
          print("Error loading news: \(error.localizedDescription)")
        } // end of switch result 구문
        
      } // end of closure newsVM.loadData {result in}
      
    } // end of .onAppear
    
  } // end of var body: some View
  
} // end of struct NewsView: View

#Preview {
  NewsView()
}
