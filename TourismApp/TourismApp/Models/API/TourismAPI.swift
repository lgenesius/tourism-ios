//
//  TourismAPI.swift
//  TourismApp
//
//  Created by Luis Genesius on 22/07/21.
//

import Foundation

struct TourismAPIResponse: Decodable {
    
    let places: [TourismAPI]
}

struct TourismAPI: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let address: String
    let longitude: Double
    let latitude: Double
    let image: String
}
