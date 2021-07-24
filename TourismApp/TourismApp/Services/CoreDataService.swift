import Foundation
import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTourism(name: String, address: String, imageURL: String, longitude: Double, latitude: Double, placeDescription: String) {
        
        let newTourism = Tourism(context: self.context)
        newTourism.name = name
        newTourism.address = address
        newTourism.imageURL = imageURL
        newTourism.longitude = longitude
        newTourism.latitude = latitude
        newTourism.longDescription = placeDescription
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllBookmarked() -> [Tourism]? {
        
        do {
            let request = Tourism.fetchRequest() as NSFetchRequest<Tourism>
            
            return try context.fetch(request)
        }
        catch {
            print("ERROR Fetch Request \(error)")
        }
        
        return nil
    }
    
    func deleteTourismBookmark(tourism: Tourism) {
        self.context.delete(tourism)
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
