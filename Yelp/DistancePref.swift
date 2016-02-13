//
//  DistancePref.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum DistancePref : String {
    case DistanceAuto = "Auto"
    case Distance03 = "0.3 miles"
    case Distance1 = "1 mile"
    case Distance5 = "5 miles"
    case Distance20 = "20 miles"
    
    static let allValues = [DistanceAuto, Distance03, Distance1, Distance5, Distance20]
}
