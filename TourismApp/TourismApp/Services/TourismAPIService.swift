import Foundation

protocol TourismAPIService {
    
    func fetchAll(completion: @escaping (Result<TourismAPIResponse, APIError>) -> ())
}

enum APIError: Error, CustomNSError {
    case apiError
    case invalidURL
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
            case .apiError:
                return "Failed to fetch data"
            case .invalidURL:
                return "Invalid url"
            case .invalidResponse:
                return "Invalid response"
            case .noData:
                return "No data"
            case .serializationError:
                return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey : localizedDescription]
    }
}
