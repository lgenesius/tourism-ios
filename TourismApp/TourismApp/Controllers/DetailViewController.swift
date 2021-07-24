import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tourismImageView: UIImageView!
    @IBOutlet weak var tourismName: UILabel!
    @IBOutlet weak var tourismAddress: UILabel!
    @IBOutlet weak var tourismLongitude: UILabel!
    @IBOutlet weak var tourismLatitude: UILabel!
    @IBOutlet weak var tourismDescription: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var placeName: String?
    var placeAddress: String?
    var placeLongitude: Double?
    var placeLatitude: Double?
    var placeDescription: String?
    var placeImageURL: String?
    
    var isFromBookmark: Bool?
    var selectedTourism: Tourism?

    override func viewDidLoad() {
        super.viewDidLoad()

        bookmarkButton.layer.cornerRadius = 10
        initViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setButtonDesign()
    }

    private func initViewData() {
        if let imageURL = placeImageURL, let name = placeName, let address = placeAddress, let longitude = placeLongitude, let latitude = placeLatitude, let description = placeDescription {
            
            ImageLoaderService.shared.getImage(urlString: imageURL) { [weak self] (data, error) in
                guard let self = self else { return }
                
                if error != nil {
                    self.tourismImageView.image = UIImage(systemName: "xmark.square")
                    return
                }
                
                self.tourismImageView.image = UIImage(data: data!)
            }
            
            tourismName.text = name
            tourismAddress.text = address
            tourismLongitude.text = String(format: "%.2f", longitude)
            tourismLatitude.text = String(format: "%.2f", latitude)
            tourismDescription.text = description
        }
    }
    
    private func setButtonDesign() {
        guard let fromBookmark = isFromBookmark else { return }
        
        if !fromBookmark {
            let tourisms = CoreDataService.shared.fetchAllBookmarked()
            
            if let tourisms = tourisms {
                var isBookmarked = false
                for tourism in tourisms {
                    if tourism.name! == self.placeName! {
                        isBookmarked = true
                        break
                    }
                }
                
                if isBookmarked {
                    bookmarkButton.isUserInteractionEnabled = false
                    bookmarkButton.setTitle("Bookmarked", for: .normal)
                    bookmarkButton.backgroundColor = .lightGray
                }
            }
        } else {
            bookmarkButton.setTitle("Unbookmark", for: .normal)
            bookmarkButton.backgroundColor = .systemRed
        }
    }
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel!.text!
        
        if buttonTitle == "Bookmark" {
            CoreDataService.shared.saveTourism(name: placeName!, address: placeAddress!, imageURL: placeImageURL!, longitude: placeLongitude!, latitude: placeLatitude!, placeDescription: placeDescription!)
            
            NotificationCenter.default.post(name: Notification.Name("dataUpdated"), object: nil)
            
            bookmarkButton.isUserInteractionEnabled = false
            bookmarkButton.setTitle("Bookmarked", for: .normal)
            bookmarkButton.backgroundColor = .lightGray
        }
        else if buttonTitle == "Unbookmark" {
            guard let selectedTourism = self.selectedTourism else { return }
            
            CoreDataService.shared.deleteTourismBookmark(tourism: selectedTourism)
            NotificationCenter.default.post(name: Notification.Name("dataUpdated"), object: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
