//
//  DropdownCell.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DropdownCell: UITableViewCell {

    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet weak var dropdownImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
