import Foundation

class TourismAPIFetch: TourismAPIService {
    
    static let shared = TourismAPIFetch()
    
    private let tourismAPIURL = "https://tourism-api.dicoding.dev/list"
    private let urlSession = URLSession.shared
    
    private init() {}
    
    func fetchAll(completion: @escaping (Result<TourismAPIResponse, APIError>) -> ()) {
        guard let url = URL(string: tourismAPIURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        processURL(url: url, completion: completion)
    }
    
    private func processURL<D: Decodable>(url: URL, completion: @escaping (Result<D, APIError>) -> ()) {
        
        let task = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.executeInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                self.executeInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(D.self, from: data)
                self.executeInMainThread(with: .success(decoded), completion: completion)
            }
            catch {
                self.executeInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }
        
        task.resume()
    }
    
    private func executeInMainThread<D: Decodable>(with result: Result<D, APIError>, completion: @escaping (Result<D, APIError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
