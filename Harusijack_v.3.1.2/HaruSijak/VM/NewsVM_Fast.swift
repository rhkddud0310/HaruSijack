import Foundation

class NewsVM_Fast {
    func loadData(completion: @escaping (Result<[NewsModel_Fast], Error>) -> Void) {
        guard let url = URL(string: "http://your_server_ip:8000/news/news") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let news = try JSONDecoder().decode([NewsModel_Fast].self, from: data)
                completion(.success(news))
                print(completion(.success(news)))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
