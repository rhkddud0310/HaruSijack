//
//  NewsArticleView.swift
//  RNDNewsRecommendation
//
//  Created by 박동근 on 6/26/24.
//

import SwiftUI
// ******************************
import WebKit
// ******************************


struct NewsArticleView: View {
    var newslink : String
    var body: some View {
        WebView(url : newslink)
    }
}
struct WebView : UIViewRepresentable{
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    let url : String
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.load(URLRequest(url: URL(string: url)!))
        return webView
    }
    
}
#Preview {
    NewsArticleView(newslink:"https://www.naver.com" )
}
