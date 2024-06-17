//  Created by G.Zen on 6/15/24.
// MARK: -- Description
/*
    Description : HaruSijack App 개발 News Crawling Page
    Date : 2024. 06. 15. (Sat)
    Author :
    Dtail :
    Updates :
        * 2024.06.15. (Sun) by. G.Zen: 기초 Design 구상
 */

import SwiftUI

//struct NewsView: View {
//  // MARK: * Property *
//  @StateObject private var viewModel = NewsViewModel()
//  
//  let columns = [
//    GridItem(.flexible()),
//    GridItem(.flexible())
//  ]
//  
//  var body: some View {
//    
//    NavigationView {
//      
//      ScrollView {
//        
//        LazyVGrid(columns: columns, spacing: 10) {
//          
//          ForEach(viewModel.recommendations) { news in
//            NewsCell(news: news)
//          } // end of closure ForEach(news in)
//          
//        } // end of LazyVGrid
//        .padding()
//        
//      } // end of ScrollView
//      .navigationTitle("🍇 Today News")
//      .navigationBarTitleDisplayMode(.automatic)
//      
//    } // end of NavigationView
//    
//  } // end of var body: some View
//} // end of struct NewsView: View

struct NewsView: View {
  
  // MARK: * Property *
  @State var newsList: [NewsModel] = []
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  //****************************************************************************
  
  var body: some View {
    
    NavigationView(content: {
      
      ScrollView(content: {

        LazyVGrid(columns: columns, spacing: 10, content: {

          ForEach(newsList, id: \.self, content: { news in
            
            NewsCell(newsTitle: news.Title, newsPress: news.Press)
            
//            NavigationLink(<#LocalizedStringKey#>, destination: NewsCell(newsTitle: news.Title, newsPress: news.Press))  // end of NavigationLink
            
          })  // end of closure ForEach(content)
          
        })  // end of LazyVGrid
        .padding()
        
      })  // end of ScrollView
      .navigationTitle("🍇 Today News")
      .navigationBarTitleDisplayMode(.automatic)
      
    })  // end of NavigationView
    .onAppear(perform: {
      let newsVM = NewsVM()
      
      //************************************************************************
      Task {
        newsList = try await newsVM.loadData(url: URL(string: "http://127.0.0.1:5000/news")!)
      } // end of Task
      //************************************************************************
      
    })  // end of .onAppear
    
  } // end of var body: some View
  
} // end of struct NewsView: View

#Preview {
  NewsView()
}
