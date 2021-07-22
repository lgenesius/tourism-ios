//
//  APIService.swift
//  TourismApp
//
//  Created by Luis Genesius on 22/07/21.
//

import Foundation

protocol TourismAPIService {
    
    func fetchAll(completion: @escaping (Result<TourismAPIResponse, APIError>) -> ())
}

enum APIError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
            case .apiError:
                return "Failed to fetch data"
            case .invalidEndpoint:
                return "Invalid endpoint"
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
