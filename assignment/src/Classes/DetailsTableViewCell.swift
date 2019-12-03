//
//  DetailsTableViewCell.swift
//  assignment
//
//  Created by Sreekanth Gudisi on 03/12/19.
//  Copyright © 2019 Manjunath. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    // IBOutlets
    @IBOutlet weak var contentUIVIew: UIView!
    @IBOutlet weak var followersImageView: UIImageView!
    @IBOutlet weak var followersNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
