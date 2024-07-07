import Foundation

class NewsVM_Fast {
    func loadData(completion: @escaping (Result<[NewsModel_Fast], Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/news/news") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                   print("Server response: \(responseString)")
               }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let news = try JSONDecoder().decode([NewsModel_Fast].self, from: data)
                completion(.success(news))
                print("**********************************")
                
                print(completion(.success(news)))
                print("**********************************")
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
