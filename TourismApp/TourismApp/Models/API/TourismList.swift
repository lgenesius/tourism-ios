import Foundation

class TourismList {
    
    var tourisms: [TourismAPI]?
    var isLoading = false
    var error: NSError?
    
    private let tourismService: TourismAPIService
    
    init(tourismService: TourismAPIService = TourismAPIFetch.shared) {
        self.tourismService = tourismService
    }
    
    func loadTourisms(completion: @escaping () -> ()) {
        self.tourisms = nil
        self.isLoading = true
        self.tourismService.fetchAll { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.tourisms = response.places
            case .failure(let error):
                self.error = error as NSError?
            }
            
            completion()
        }
    }
}
