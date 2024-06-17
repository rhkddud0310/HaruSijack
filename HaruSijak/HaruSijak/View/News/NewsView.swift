////  Created by 신나라 on 6/1/24.
//// MARK: -- Description
///*
//    Description : HaruSijack App 개발 News Crawling Page
//    Date : 2024. 06. 01
//    Author :
//    Dtail :
//    Updates :
//        * 2024.06.16. (Sun) by. G.Zen:
// */
//
//import SwiftUI
//
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
//      .navigationTitle("News Recommendations")
//      
//    } // end of NavigationView
//    
//  } // end of var body: some View
//} // end of struct NewsView: View
//
//#Preview {
//  NewsView()
//}
