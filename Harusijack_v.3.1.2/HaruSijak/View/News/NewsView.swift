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
    @State var newsList: [NewsModel] = []
    @State var searchValue: String = ""
    @FocusState var isTextFieldFocused: Bool
    @State var selectedSegment: String = ""
    @State var emotion: [String] = ["전체", "슬픈" , "기쁜", "사랑", "화남", "두려운", "놀라운"]
    @State var positive: [String] = ["긍정적 기사", "부정적 기사"]
    let emojis = ["😊", "😭", "🥰", "😠", "😱", "😲"]
    let labels = ["기뻐요", "슬퍼요", "사랑해요", "화나요", "무서워요", "놀라워요"]
    let percentages = ["80%", "30%", "20%", "15%", "50%", "20%"]
  
  var body: some View {
      
      
          ScrollView(content: {
              VStack(alignment:.leading,content: {
                  
                    //검색필드
//                  HStack(content: {
//                      Spacer()
//                      TextField("검색어를 입력하세요.", text: $searchValue)
//                          .frame(width: UIScreen.main.bounds.width*0.8)
//                          .textFieldStyle(.roundedBorder)
//                          .focused($isTextFieldFocused)
//                      Button(action: {
//                      }, label: {
//                          Image(systemName: "magnifyingglass")
//                              .font(.system(size: 25))
//                              .foregroundStyle(.black)
//                      })
//                      Spacer()
//                  })
//                  .padding(.top, 30)
                  Text("     감정선택")
                      .bold()
                      .font(.system(size: 10))
//                      .font(.custom("Ownglyph_noocar-Rg", size: 40))
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
                  
                  ForEach(newsList, id: \.self) { news in
                      NavigationLink(destination: NewsArticleView(newslink: news.Link), label: {
                          VStack(alignment:.leading,content:{
                              Text(news.Press)
                                .font(.headline)
                                .padding([.top, .leading, .trailing])
//                                .foregroundColor(.primary)
                              
                              Text(news.Title)
                                .font(.subheadline)
                                .padding([.leading, .bottom, .trailing])
                                .frame(alignment:.leading)
//                                .foregroundStyle(Color.gray)
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
                                              Text(percentages[index])
                                                  .font(.system(size: 10))
                                              Spacer()
                                          }
                                          Spacer()
                                      }
                                  }
                              }
                              .frame(maxWidth: .infinity)
                          })//VS
                        .background(Color.white)
//                        .shadow(radius: 4)
                        .padding([.top, .horizontal])
                      })//NVLInk
                      .buttonStyle(PlainButtonStyle())
                  }//FE
              })//VS
          })//SV
      
      .onAppear {
          let newsVM = NewsVM()
          newsVM.loadData(url: URL(string: "http://127.0.0.1:5000/news")!) { result in
              switch result {
              case .success(let news):DispatchQueue.main.async {
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
