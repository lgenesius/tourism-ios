import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!

    let tourism = TourismList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tourism.loadTourisms {
            print(self.tourism.tourisms![0])
        }
    }

    
}
