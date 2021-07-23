import Foundation
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoaderService {
    
    static let shared = ImageLoaderService()
    
    private let urlSession = URLSession.shared
    
    func getImage(urlString: String, completion: @escaping (Data?, APIError?) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidURL)
            return
        }
        
        loadImage(url: url, completion: completion)
    }
    
    private func loadImage(url: URL, completion: @escaping (Data?, APIError?) -> ()) {
        
        let task = urlSession.downloadTask(with: url) { [weak self] (localURL, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionInMainThread(data: nil, error: .apiError, completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.executeCompletionInMainThread(data: nil, error: .invalidResponse, completion: completion)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                self.executeCompletionInMainThread(data: nil, error: .invalidResponse, completion: completion)
                return
            }
            
            guard let localURL = localURL else {
                self.executeCompletionInMainThread(data: nil, error: .invalidURL, completion: completion)
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                
                self.executeCompletionInMainThread(data: data, error: nil, completion: completion)
            }
            catch {
                self.executeCompletionInMainThread(data: nil, error: .serializationError, completion: completion)
            }
        }
        
        task.resume()
    }
    
    private func executeCompletionInMainThread(data: Data?, error: APIError?, completion: @escaping (Data?, APIError?) -> ()) {
        DispatchQueue.main.async {
            completion(data, error)
        }
    }
}
