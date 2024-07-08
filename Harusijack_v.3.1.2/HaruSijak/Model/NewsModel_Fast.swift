import Foundation

struct NewsModel_Fast: Codable {
    let date: String
    let title: String
    let link: String
    let content: String
    let newContent: String
    let translatedContent: String
    let sadness: Double
    let joy: Double
    let love: Double
    let anger: Double
    let fear: Double
    let surprise: Double

    enum CodingKeys: String, CodingKey {
        case date, title, link, content, newContent
        case translatedContent = "translated_content"
        case sadness, joy, love, anger, fear, surprise
    }
}
