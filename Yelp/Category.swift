//
//  Category.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Category {
    var name: String
    var code: String
    var selected: Bool
    
    init(name: String, code: String, selected: Bool) {
        self.name = name
        self.code = code
        self.selected = selected
    }
}