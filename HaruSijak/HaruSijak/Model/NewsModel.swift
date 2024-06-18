//
//  NewsModel.swift
//  HaruSijak
//
//  Created by G.Zen on 2024-06-17.
//

// MARK: -- Description
/*
    Description : HaruSijack App 개발 News Crawling Page
    Date : 2024. 06. 17. (Mon)
    Author :
    Detail :
 
        1. import Foundation: Foundation이라는 기본 라이브러리를 가져옵니다.
          1-1. 이 라이브러리는 날짜와 시간, 파일 관리, 네트워킹 등 기본적인 기능을 제공합니다.

        2. struct NewsModel: NewsModel이라는 구조체(데이터 모델)를 정의합니다.
          2-1. : Decodable, Identifiable, Hashable: NewsModel은 Decodable, Identifiable, Hashable 세 가지 프로토콜을 따릅니다.
          2-2. Decodable: JSON과 같은 외부 데이터를 이 모델로 변환할 수 있습니다.
          2-3. Identifiable: 고유 식별자가 있어 SwiftUI의 리스트나 그리드에서 쉽게 사용할 수 있습니다.
          2-4. Hashable: 객체를 해시할 수 있어 딕셔너리 키로 사용할 수 있습니다.

        3. Property
          3-1. let id: UUID: 각 뉴스 항목에 고유한 식별자인 UUID(범용 고유 식별자)를 부여합니다. 이는 자동으로 생성됩니다.
          3-2. let Link: String: 뉴스 기사의 링크(URL)를 저장하는 문자열 속성입니다.
          3-3. let Press: String: 뉴스 기사를 발행한 언론사의 이름을 저장하는 문자열 속성입니다.
          3-4. let Title: String: 뉴스 기사의 제목을 저장하는 문자열 속성입니다.
          3-5. let content: String: 뉴스 기사의 내용을 저장하는 문자열 속성입니다.
          3-6. let keywords: String: 뉴스 기사와 관련된 키워드들을 저장하는 문자열 속성입니다.

        4. init(from decoder: Decoder) throws: 이니셜라이저(initializer)로, JSON 데이터를 NewsModel로 변환할 때 사용됩니다.
          4-1. let container = try decoder.container(keyedBy: CodingKeys.self): JSON 데이터를 읽기 위해 컨테이너를 만듭니다. CodingKeys를 사용해 JSON 키를 매핑합니다.
          4-2. self.id = UUID(): 새 UUID를 생성해 id 속성에 할당합니다.
          4-3. self.Link = try container.decode(String.self, forKey: .Link): JSON에서 Link 키의 값을 읽어 Link 속성에 할당합니다.
          4-4. self.Press = try container.decode(String.self, forKey: .Press): JSON에서 Press 키의 값을 읽어 Press 속성에 할당합니다.
          4-5. self.Title = try container.decode(String.self, forKey: .Title): JSON에서 Title 키의 값을 읽어 Title 속성에 할당합니다.
          4-6. self.content = try container.decode(String.self, forKey: .content): JSON에서 content 키의 값을 읽어 content 속성에 할당합니다.
          4-7. self.keywords = try container.decode(String.self, forKey: .keywords): JSON에서 keywords 키의 값을 읽어 keywords 속성에 할당합니다.

        5. enum CodingKeys: String, CodingKey: JSON 키와 NewsModel 속성을 연결하기 위해 사용되는 열거형(enum)입니다.
          5-1. case Link, Press, Title, content, keywords: JSON의 키 이름과 구조체의 속성 이름이 동일할 때 사용합니다.
          5-2. case Unnamed = “Unnamed: 0”: JSON의 키 이름이 Unnamed: 0인 경우를 처리하기 위한 매핑입니다. (현재 사용되지 않음)

        6. func hash(into hasher: inout Hasher): Hashable 프로토콜을 따르기 위해 필요한 메서드입니다. 이 메서드는 객체를 해시하는 방법을 정의합니다.
          6-1. hasher.combine(id): id를 사용해 객체를 해시합니다.

    Updates :
        * 2024.06.17. (Mon) by. G.Zen: 기초 Design 구상
 */

import Foundation

struct NewsModel: Decodable, Identifiable, Hashable {
  
  // MARK: * Property *
  let id: UUID
  let Link: String
  let Press: String
  let Title: String
  let content: String
  let keywords: String

  // Custom initializer to handle missing UUID in JSON
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = UUID() // Generate a UUID here
    self.Link = try container.decode(String.self, forKey: .Link)
    self.Press = try container.decode(String.self, forKey: .Press)
    self.Title = try container.decode(String.self, forKey: .Title)
    self.content = try container.decode(String.self, forKey: .content)
    self.keywords = try container.decode(String.self, forKey: .keywords)
  } // end of init(from decoder)
  
  enum CodingKeys: String, CodingKey {
    case Link
    case Press
    case Title
    case content
    case keywords
//    case Unnamed = "Unnamed: 0"
  } // end of enum CodingKeys: String, CodingKey

  //**************************************************************************************************************************
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  } // end of functions hash(into, inout)
  //**************************************************************************************************************************
  
} // struct NewsModel: Decodable, Identifiable, Hashable
