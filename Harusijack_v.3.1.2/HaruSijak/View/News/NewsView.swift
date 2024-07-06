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
    * 뉴스기사 안나옴.
 
 */

import SwiftUI

struct NewsView: View {
  
    // MARK: * Property *
    @State var newsList: [NewsModel_Fast] = []
    @State var searchValue: String = ""
    @FocusState var isTextFieldFocused: Bool
    @State var selectedSegment: String = ""
    @State var emotion: [String] = ["전체", "슬픈" , "기쁜", "사랑", "화남", "두려운", "놀라운"]
    @State var positive: [String] = ["긍정적 기사", "부정적 기사"]
    let emojis = ["😊", "😭", "🥰", "😠", "😱", "😲"]
    let labels = ["기뻐요", "슬퍼요", "사랑해요", "화나요", "무서워요", "놀라워요"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("     감정선택")
                    .bold()
                    .font(.system(size: 10))
                
                Picker("감정 선택 ", selection: $selectedSegment) {
                    ForEach(0..<emotion.count, id: \.self) { index in
                        Text(emotion[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("     긍정 부정선택(임시)")
                    .bold()
                    .font(.system(size: 10))
                
                Picker("감정 선택 ", selection: $selectedSegment) {
                    ForEach(0..<positive.count, id: \.self) { index in
                        Text(positive[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ForEach(newsList, id: \.link) { news in
                    NavigationLink(destination: NewsArticleView(newslink: news.link)) {
                        VStack(alignment: .leading) {
                            Text(news.title)
                                .font(.headline)
                                .padding([.top, .leading, .trailing])
                            
                            Text(news.newContent.prefix(100) + (news.newContent.count > 100 ? "..." : ""))
                                .font(.subheadline)
                                .padding([.leading, .bottom, .trailing])
                                .frame(alignment: .leading)
                            
                            HStack {
                                Text("기사 감성예측")
                                ForEach(0..<6) { index in
                                    VStack {
                                        Spacer()
                                        VStack {
                                            Text(emojis[index])
                                                .font(.system(size: 30))
                                            Text(labels[index])
                                                .font(.system(size: 12))
                                            Text(getPercentage(for: index, news: news))
                                                .font(.system(size: 10))
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .background(Color.white)
                        .padding([.top, .horizontal])
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .onAppear {
            let newsVM = NewsVM_Fast()
            newsVM.loadData { result in
                switch result {
                case .success(let news):
                    DispatchQueue.main.async {
                        newsList = news
                    }
                case .failure(let error):
                    print("Error loading news: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getPercentage(for index: Int, news: NewsModel_Fast) -> String {
        let percentage: Double
        switch index {
        case 0: percentage = news.joy
        case 1: percentage = news.sadness
        case 2: percentage = news.love
        case 3: percentage = news.anger
        case 4: percentage = news.fear
        case 5: percentage = news.surprise
        default: percentage = 0
        }
        return String(format: "%.0f%%", percentage * 100)
    }
} // end of struct NewsView: View


#Preview {
  NewsView()
}
