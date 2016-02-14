//
//  YelpAnnotation.swift
//  Yelp
//
//  Created by Hieu Nguyen on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class YelpAnnotation: MKPointAnnotation {
    var business: Business?
    
    override init() {
        super.init()
        business = nil
    }
    
    init(coordinate: CLLocationCoordinate2D, business: Business) {
        super.init()
        
        self.coordinate = coordinate
        self.business = business
    }
}
