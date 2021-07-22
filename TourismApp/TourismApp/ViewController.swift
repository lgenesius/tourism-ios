//
//  ViewController.swift
//  TourismApp
//
//  Created by Luis Genesius on 22/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    let tourism = TourismList()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tourism.loadTourisms {
            print(self.tourism.tourisms![0])
        }
        
    }
}

