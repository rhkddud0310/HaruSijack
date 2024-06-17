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

struct NewsView: View {
  // MARK: * Property *
  @StateObject private var viewModel = NewsViewModel()
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    
    NavigationView {
      
      ScrollView {
        
        LazyVGrid(columns: columns, spacing: 10) {
          
          ForEach(viewModel.recommendations) { news in
            NewsCell(news: news)
          } // end of closure ForEach(news in)
          
        } // end of LazyVGrid
        .padding()
        
      } // end of ScrollView
      .navigationTitle("🍇 Today News")
      .navigationBarTitleDisplayMode(.automatic)
      
    } // end of NavigationView
    
  } // end of var body: some View
} // end of struct NewsView: View

#Preview {
  NewsView()
}
