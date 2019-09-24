//
//  ItemCell.swift
//  Caption Items
//
//  Created by Mihai Leonte on 9/24/19.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var imageLabel: UILabel!
    @IBOutlet var viewsLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
