//
//  DetailViewController.swift
//  Caption Items
//
//  Created by Mihai Leonte on 9/24/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var imagePath: String?
    var imageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = imagePath {
            imageView.image = UIImage(contentsOfFile: path)
        }
        
        if let title = imageTitle {
            self.title = title
        }
        
    }
    


}
