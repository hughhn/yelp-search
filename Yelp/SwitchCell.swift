//
//  SwitchCell.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

//
//  SwitchCell.swift
//  Yelp
//
//  Created by Hugo Nguyen on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell,
        didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    weak var delegate: SwitchCellDelegate?
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: "switchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func switchValueChanged(mySwitch: UISwitch) {
        delegate?.switchCell?(self, didChangeValue: mySwitch.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
