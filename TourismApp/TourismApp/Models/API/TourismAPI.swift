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
