//
//  Preferences.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Preferences: NSObject, NSCopying {
    var deal: Bool
    var distance: YelpDistance!
    var sortMode: YelpSortMode!
    var categories: [String]
    
    required override init() {
        self.deal = false
        self.distance = YelpDistance.DistanceAuto
        self.sortMode = YelpSortMode.BestMatched
        self.categories = [String]()
    }
    
    required init(prefs: Preferences) {
        self.deal = prefs.deal
        self.distance = prefs.distance
        self.sortMode = prefs.sortMode
        self.categories = prefs.categories
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init(prefs: self)
    }
}