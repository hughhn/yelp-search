//
//  Preferences.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

class Preferences: NSObject {
    var
    deal = false,
    distanceAuto = true,
    distance03 = false,
    distance1 = false,
    distance5 = false,
    distance20 = false,
    sortBestMatch = true,
    sortDistance = false,
    sortHighestRated = false,
    categories = [String]()
}