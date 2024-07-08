import Foundation
import SwiftUI

struct ChatBotTest: View {
    @State private var responseMessage: String = ""

    var body: some View {
        VStack {
            Text("Response: \(responseMessage)")
            Button(action: {
                fetchResponse(message: "야 너 바보냐 ") { result in
                    switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            self.responseMessage = response
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.responseMessage = "Error: \(error.localizedDescription)"
                        }
                    }
                }
            }) {
                Text("Send Message")
            }
        }
    }

    func fetchResponse(message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/chat-api") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        print("server request: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = ["request_message": message]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "HTTP error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responseMessage = json["response_message"] as? String {
                    completion(.success(responseMessage))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

#Preview {
    ChatBotTest()
}
