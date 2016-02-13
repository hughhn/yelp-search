//
//  Preferences.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Preferences: NSObject {
    var deal: Bool
    var distance: YelpDistance!
    var sortMode: YelpSortMode!
    var categories: [String]
    
    override init() {
        self.deal = false
        self.distance = YelpDistance.DistanceAuto
        self.sortMode = YelpSortMode.BestMatched
        self.categories = [String]()
    }
    
}