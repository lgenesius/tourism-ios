import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var meImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        meImageView.layer.cornerRadius = 10
    }

}
