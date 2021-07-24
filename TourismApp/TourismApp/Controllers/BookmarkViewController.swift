import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    private var tourisms = [Tourism]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("dataUpdated"), object: nil)

        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        
        let nib = UINib(nibName: "\(TourismTableViewCell.self)", bundle: nil)
        bookmarkTableView.register(nib, forCellReuseIdentifier: "tourismCell")
        
        loadTourisms()
    }

    private func loadTourisms() {
        
        if let tempTourisms = CoreDataService.shared.fetchAllBookmarked() {
            
            self.tourisms = tempTourisms
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.bookmarkTableView.reloadData()
            }
        }
    }
    
    private func navigateToDetail(indexPath: IndexPath) {
        if tourisms.count > 0 {
            let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let detailVC = detailStoryboard.instantiateViewController(identifier: "detail") as! DetailViewController
            
            detailVC.placeName = tourisms[indexPath.row].name
            detailVC.placeAddress = tourisms[indexPath.row].address
            detailVC.placeLongitude = tourisms[indexPath.row].longitude
            detailVC.placeLatitude = tourisms[indexPath.row].latitude
            detailVC.placeDescription = tourisms[indexPath.row].longDescription
            detailVC.placeImageURL = tourisms[indexPath.row].imageURL
            
            detailVC.isFromBookmark = true
            detailVC.selectedTourism = tourisms[indexPath.row]
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    @objc private func reloadTableView() {
        loadTourisms()
    }
}

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bookmarkTableView.deselectRow(at: indexPath, animated: true)
        
        navigateToDetail(indexPath: indexPath)
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tourisms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "tourismCell") as! TourismTableViewCell
        
        ImageLoaderService.shared.getImage(urlString: tourisms[indexPath.row].imageURL!) { (data, error) in
            
            if error != nil {
                cell.tourismImageView.image = UIImage(systemName: "xmark.square")
                return
            }
            
            cell.tourismImageView.image = UIImage(data: data!)
            cell.tourismImageView.layer.cornerRadius = 10
        }
        
        cell.nameLabel.text = tourisms[indexPath.row].name
        cell.addressLabel.text = tourisms[indexPath.row].address
        
        cell.selectionStyle = .none
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
    
}
