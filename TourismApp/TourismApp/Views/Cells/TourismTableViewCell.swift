//
//  TourismTableViewCell.swift
//  TourismApp
//
//  Created by Luis Genesius on 22/07/21.
//

import UIKit

class TourismTableViewCell: UITableViewCell {

    @IBOutlet weak var tourismImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
    }
}
