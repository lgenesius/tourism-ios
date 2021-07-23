import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)

    private let tourism = TourismList()
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setActivityIndicator()
        
        tourism.loadTourisms {
            
            self.images.removeAll()
            self.homeTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        let nib = UINib(nibName: "\(TourismTableViewCell.self)", bundle: nil)
        homeTableView.register(nib, forCellReuseIdentifier: "tourismCell")
    }
    
    private func setActivityIndicator() {
        activityIndicator.alpha = 1.0
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        activityIndicator.startAnimating()
    }
    
    private func navigateToDetail(indexPath: IndexPath) {
        if let tourisms = tourism.tourisms {
            let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let detailVC = detailStoryboard.instantiateViewController(identifier: "detail") as! DetailViewController
            
            detailVC.placeImage = images[indexPath.row]
            detailVC.placeName = tourisms[indexPath.row].name
            detailVC.placeAddress = tourisms[indexPath.row].address
            detailVC.placeLongitude = tourisms[indexPath.row].longitude
            detailVC.placeLatitude = tourisms[indexPath.row].latitude
            detailVC.placeDescription = tourisms[indexPath.row].description
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTableView.deselectRow(at: indexPath, animated: true)
        
        navigateToDetail(indexPath: indexPath)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       tourism.tourisms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "tourismCell") as! TourismTableViewCell
        
        cell.tourismImageView.image = UIImage(systemName: "questionmark.square")
        
        if let tourismList = tourism.tourisms {
            cell.nameLabel.text = tourismList[indexPath.row].name
            cell.addressLabel.text = tourismList[indexPath.row].address
            
            ImageLoaderService.shared.getImage(urlString: tourismList[indexPath.row].image) { [weak self] (data, error) in
                
                if error != nil {
                    cell.tourismImageView.image = UIImage(systemName: "xmark.square")
                    return
                }
                
                cell.tourismImageView.image = UIImage(data: data!)
                cell.tourismImageView.layer.cornerRadius = 10
                
                self?.images.append(cell.tourismImageView.image!)
            }
        }
        else if let error = tourism.error {
            cell.tourismImageView.image = UIImage(systemName: "xmark.square")
            cell.nameLabel.text = error.localizedDescription
            cell.addressLabel.text = ""
            
            images.append(cell.tourismImageView.image!)
        }
        
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
}
