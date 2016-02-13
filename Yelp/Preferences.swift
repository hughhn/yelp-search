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
    var distanceAuto: Bool
    var distance03: Bool
    var distance1: Bool
    var distance5: Bool
    var distance20: Bool
    var sortBestMatch: Bool
    var sortDistance: Bool
    var sortHighestRated: Bool
    var categories: [String]
    
    override init() {
        self.deal = false
        self.distanceAuto = true
        self.distance03 = false
        self.distance1 = false
        self.distance5 = false
        self.distance20 = false
        self.sortBestMatch = true
        self.sortDistance = false
        self.sortHighestRated = false
        self.categories = [String]()
    }
    
}