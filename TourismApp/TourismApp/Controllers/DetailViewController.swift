import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tourismImageView: UIImageView!
    @IBOutlet weak var tourismName: UILabel!
    @IBOutlet weak var tourismAddress: UILabel!
    @IBOutlet weak var tourismLongitude: UILabel!
    @IBOutlet weak var tourismLatitude: UILabel!
    @IBOutlet weak var tourismDescription: UILabel!
    
    var placeImage: UIImage?
    var placeName: String?
    var placeAddress: String?
    var placeLongitude: Double?
    var placeLatitude: Double?
    var placeDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        initViewData()
    }

    private func initViewData() {
        if let image = placeImage, let name = placeName, let address = placeAddress, let longitude = placeLongitude, let latitude = placeLatitude, let description = placeDescription {
            
            tourismImageView.image = image
            tourismName.text = name
            tourismAddress.text = address
            tourismLongitude.text = String(longitude)
            tourismLatitude.text = String(latitude)
            tourismDescription.text = description
        }
    }
}
